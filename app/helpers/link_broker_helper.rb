module LinkBrokerHelper
  def link_broker
    unless result = $memcache.get("broker_links_#{ request.request_uri }")
      result = Net::HTTP.get(
        URI.parse("http://links.radiushosting.ru/get_links.php?url=%s&host=%s&charset=utf-8" % [
          URI.escape(request.request_uri.to_s),
          'mediazavod.ru'
        ])
      )

      $memcache.set("link_broker_#{ request.request_uri }", result, 1.hour)
    end

    result
  end
end