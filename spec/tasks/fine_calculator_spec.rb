require 'rails_helper'
require 'pp'
require 'rake'
require 'chronic'

describe 'fine_calculator namespace rake task' do
    describe 'fine_calculator:start' do
        before do 
            load File.expand_path("../../../lib/tasks/fine_calculator.rake", __FILE__)
            Rake::Task.define_task(:environment)
        end 
        
        it 'should not call weekly_hours_addition on non-Sundays' do
            @time_now = Chronic.parse("Monday")
            allow(Time).to receive(:now).and_return(@time_now)
            Rake::Task["fine_calculator:start"].invoke
            
            User.should_not_receive :weekly_hours_addition
        end 
        
        # it 'should call weekly_hours_addition on Sundays' do
        #     @time_now = Chronic.parse("Sunday")
        #     allow(Time).to receive(:now).and_return(@time_now)
        #     Rake::Task["fine_calculator:start"].invoke
            
        #     User.should_receive :weekly_hours_addition
        # end 
    end 
end 