desc 'run coincheck process'
task coincheck: :environment do
  InitiateCoinReviewService.new.call
end
