# == Define: beaver::output::kafka
#
#   send events to a kafka broker
#
#
# === Parameters
#
# [*host*]
#   Kafka host to submit to
#   Value type is string
#   This variable is mandatory
#
# [*port*]
#   Kafka port number
#   Value type is number
#   Default value: 9092
#   This variable is optional
#
# [*topic*]
#   Kafka topic
#   Value type is string
#   Default value: logstash-topic
#   This variable is optional
#
# [*client_id*]
#   Kafka client id
#   Value type is string
#   Default value: beaver-kafka
#   This variable is optional

# === Examples
#
#  beaver::output::kafka{'kafkaout':
#    host => 'kafkahost'
#  }
#
# === Authors
#
# * Michael Gaber <mailto:michael.gaber@digital-media-products.de>
#
define beaver::output::kafka(
  $host,
  $port      = 9092,
  $topic     = 'logstash-topic'
  $client_id = 'beaver-kafka'
) {

  #### Validate parameters
  if $host {
    validate_string($host)
  }

  if ! is_numeric($port) {
    fail("\"${port}\" is not a valid port parameter value")
  }

  $opt_host = "kafka_host: ${host}:${port}\n"

  validate_string($topic)

  $opt_topic = "kafka_topic: ${topic}\n"

  validate_string($client_id)

  $opt_client_id = "kafka_client_id: ${client_id}\n"

  #### Create file fragment

  file_fragment{ "output_kafka_${::fqdn}":
    tag     => "beaver_config_${::fqdn}",
    content => "{opt_host}${opt_topic}${opt_client_id}\n"
    order   => 20
  }

}
