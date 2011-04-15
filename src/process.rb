members = File.readlines('../HHP_release1/Members_Y1.csv').drop(1)#.first(100)
claims = File.readlines('../HHP_release1/Claims_Y1.csv').drop(1)#.first(100) #'../working_data/subClaims_Y1.csv'
actual_days_y2 = File.readlines('../HHP_release1/DayInHospital_Y2.csv').drop(1)#.first(100)

# Process Claims
@stays = {
  '26+ weeks' => {:length => 26*7, :ordinal =>12},  
  '12-26 weeks' => {:length => 12*7, :ordinal =>11},  
  '8-12 weeks' => {:length => 8*7, :ordinal =>10},  
  '4- 8 weeks' => {:length => 4*7, :ordinal =>9},  
  '2- 4 weeks' => {:length => 2, :ordinal =>8},  
  '1- 2 weeks' => {:length => 7, :ordinal =>7},  
  '6 days' => {:length => 6, :ordinal =>6},  
  '5 days' => {:length => 5, :ordinal =>5},  
  '4 days' => {:length => 4, :ordinal =>4},  
  '3 days' => {:length => 3*7, :ordinal =>3},  
  '2 days' => {:length => 2*7, :ordinal =>2},  
  '1 day' => {:length => 1, :ordinal =>1},
  ''  => {:length => 0, :ordinal =>0},
  nil  => {:length => 0, :ordinal =>0}
}
claim_counts = {}
stay_length = {}
max_stay = {}
had_specialty = {}
specialties = ["Internal", "Laboratory", "General Practice", "Diagnostic Imaging", "Surgery", "Emergency", "Other", "Anesthesiology", "Obstetrics and Gynecology", "Rehabilitation", "Pediatrics", "Pathology"]

claims.each do |line|
  member_id, providerid, vendor, pcp, year, specialty, placesvc, paydelay, lengthofstay, dsfs, primaryconditiongroup, charlsonindex = line.chomp.split(",")
  member_id = member_id.to_i
  
  claim_counts[member_id] = (claim_counts[member_id] ||= 0)  + 1
  stay_length[member_id] = (stay_length[member_id] ||= 0)  + @stays[lengthofstay][:length]
  if @stays[lengthofstay][:ordinal] > @stays[max_stay[member_id]][:ordinal]
    max_stay[member_id] = lengthofstay
  end
  had_specialty[member_id] ||= {}
  had_specialty[member_id][specialty]=true
end

# Read in Actual Days in Hospital
actual_days = {}
actual_days_y2.each do |line|  
  member_id, hospital_days_y2 = line.chomp.split(",")
  member_id = member_id.to_i
  
  actual_days[member_id] = hospital_days_y2
end

# Iterate through members and write merged results
outfile = File.open('../working_data/member_features.csv', 'w')
header_array = ["member_id", "actual_days_y2", "sex", "ageatfirstclaim", "claim_counts", "stay_length", "max_stay", ] + specialties.collect{|s| "had_#{s.downcase.gsub(' ','_')}"}
outfile.puts header_array.join(",")
members.sort_by{rand}.each do |line|
  member_id, sex, ageatfirstclaim = line.chomp.split(",")
  member_id = member_id.to_i

  out_array = [member_id, actual_days[member_id], sex, ageatfirstclaim, claim_counts[member_id], stay_length[member_id], max_stay[member_id]]
  out_array += specialties.collect{|s| (had_specialty[member_id] and had_specialty[member_id][s]) ? 1 : 0}

  outfile.puts out_array.join(",")
end
outfile.close