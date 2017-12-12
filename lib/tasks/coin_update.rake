desc 'say hello'
task hello: :environment do
  CoinCheckService.new.searcher
end
