desc 'run coincheck process'
task coincheck: :environment do
  InitiateCoinReviewService.new.call
  puts "This is executed from scheduler"
end
