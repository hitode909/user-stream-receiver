$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'user_stream_receiver'
require 'json'
require 'mongo'
include Mongo

db   = Connection.new.db('twitter')
# db.collection('status').remove
# db.collection('friends').remove
# db.collection('event').remove

UserStreamReceiver.new.run{|chunk|
  data = JSON.parse(chunk)
  coll_key = data['friends'] ? 'friends'
  : data['event'] ? 'event'
  : 'status'
  db.collection(coll_key).insert(data)

  p data
  p coll_key
}
