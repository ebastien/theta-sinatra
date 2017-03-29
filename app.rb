require 'sinatra'
require 'cassandra'

cluster = Cassandra.cluster(hosts: ['node.cassandra.l4lb.thisdcos.directory'])
session = cluster.connect("demo")

get '/' do
  future = session.execute_async('SELECT key, value FROM theta LIMIT 1')
  key, value = "", ""
  future.on_success do |rows|
    rows.each do |row|
      key, value = row['key'], row['value']
    end
  end
  future.join
  "{ \"key\": \"#{key}\", \"value\": \"#{value}\" }"
end
