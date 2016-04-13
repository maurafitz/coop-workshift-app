class Metashift < ActiveRecord::Base
    has_many :shifts
    has_many :preferences
    belongs_to :unit
    
    def self.import(file)
      spreadsheet = open_spreadsheet(file)
      header = spreadsheet.row(1)
      added = []
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        metashift = find_by(name: row["name"]) || new
        metashift.attributes = row.to_hash.slice(*%w[category name description multiplier])
        if metashift.save!
          added << metashift
          create_shift_instances(metashift, row.to_hash.slice('times')['times'])
        end
      end
      return added
    end
    
    def self.create_shift_instances(metashift, csv_times) 
      all_times = csv_times.split(';')
      all_times.each do |time_slot|
        time_slot = time_slot.squish
        time_details = time_slot.split(',')
        day = time_details[0].squish
        start_and_end = time_details[1].split('to')
        start_time = start_and_end[0].squish
        end_time = start_and_end[1].squish 
        Shift.add_shift(day, start_time, end_time, metashift)
      end
    end
    
    def self.open_spreadsheet(file)
      case File.extname(file.original_filename)
        when ".csv" then Roo::CSV.new(file.path, csv_options: {encoding: "iso-8859-1:utf-8"})
        else raise "Unknown file type: #{file.original_filename}"           
      end
    end
    
    def get_all_times()
      all_shifts = self.shifts
      times = []
      all_shifts.each do |shift|
        times.push(shift.getTimeFormatted)
      end
      return times
    end
    
end
