# Description
#   AppAnnie analytics by N42 Corp
#
# Dependencies:
#   "<none>": "<none>"
#
# Configuration:
#   ANNIE_TOKEN
#   ANNIE_ACCOUNT_ID_IOS
#   ANNIE_ACCOUNT_ID_ANDROID
#   ANNIE_APP_ID_IOS
#   ANNIE_APP_ID_ANDROID
#   ANNIE_COUNTRIES
#
# Commands:
#   annie rank <platform> <range> - Returns last known <range(today,week,month)> rank for <platform>
#   annie sales <platform> <range> - Returns last known <range(today,week,month,all)> sales for <platform>
#
# Notes:
#   <platform> "ios" or "android"
#   <range> "today", "week" or "month" ("all" is only sales)
#
# Author:
#   seapy


api_path = 'https://api.appannie.com/v1.2'
api_token = 'Bearer ' + process.env.ANNIE_TOKEN

globalOptions = {
  account_id: '',
  account_id_ios: process.env.ANNIE_ACCOUNT_ID_IOS,
  account_id_android: process.env.ANNIE_ACCOUNT_ID_ANDROID,
  app_id: '',
  app_id_ios: process.env.ANNIE_APP_ID_IOS,
  app_id_android: process.env.ANNIE_APP_ID_ANDROID,
  start_date: '',
  end_date: '',
  countries: process.env.ANNIE_COUNTRIES or 'US',
  page_index: '0'
}

# Offset in days
get_current_date = (offset) ->
    now = new Date()
    now.setDate(now.getDate()+offset)
    now_day = now.getDate()
    now_year = now.getFullYear()
    now_month = now.getMonth()+1
    return now_formatted = now_year+'-'+now_month+'-'+now_day

module.exports = (robot) ->
  robot.respond /annie rank(?:( ios| android))?(?:( week| month))?/i, (msg) ->
    platform = msg.match[1] or 'both'
    platform = platform.replace(' ', '')
    range = msg.match[2] or 'today'
    range = range.replace(' ', '')
    localOptions = globalOptions

    unless platform is 'both'
      msg.send 'Checking '+platform+' platform...'
      if platform is 'ios'
        account_id = globalOptions.account_id_ios
        app_id = globalOptions.app_id_ios
        if range is 'today'
          start_date = get_current_date(-1)
        if range is 'week'
          start_date = get_current_date(-9)
        if range is 'month'
          start_date = get_current_date(-33)
        end_date = get_current_date(-1)

      else if platform is 'android'
        platform = 'google-play'
        account_id = globalOptions.account_id_android
        app_id = globalOptions.app_id_android
        if range is 'today'
          start_date = get_current_date(-1)
        if range is 'week'
          start_date = get_current_date(-10)
        if range is 'month'
          start_date = get_current_date(-34)
        end_date = get_current_date(-1)

      end_point = "/apps/#{platform}/app/#{app_id}/ranks?start_date=#{start_date}&end_date=#{end_date}"
      msg.http(api_path + end_point)
        .headers(Authorization: api_token, Accept: 'application/json')
        .get() (err, res, body) ->
          data = JSON.parse body
          for category in data.product_ranks
            ranks = []
            for date, rank of category.ranks
              ranks.push "#{date} : #{rank}"
            ranks.sort()
            msg.send "#{category.country} : #{category.feed} : #{category.category}\n" + ranks.join("\n")
    else
      msg.send 'Platform must be specified "android" or "ios"'

  robot.respond /annie sales(?:( ios| android))?(?:( week| month| all))?/i, (msg) ->
    platform = msg.match[1] or 'both'
    platform = platform.replace(' ', '')
    range = msg.match[2] or 'today'
    range = range.replace(' ', '')
    localOptions = globalOptions

    unless platform is 'both'
      msg.send 'Checking '+platform+' platform...'
      if platform is 'ios'
        account_id = globalOptions.account_id_ios
        app_id = globalOptions.app_id_ios
        if range is 'today'
          start_date = get_current_date(-1)
        if range is 'week'
          start_date = get_current_date(-9)
        if range is 'month'
          start_date = get_current_date(-33)
        end_date = get_current_date(-1)

      else if platform is 'android'
        account_id = globalOptions.account_id_android
        app_id = globalOptions.app_id_android
        if range is 'today'
          start_date = get_current_date(-1)
        if range is 'week'
          start_date = get_current_date(-10)
        if range is 'month'
          start_date = get_current_date(-34)
        end_date = get_current_date(-1)

      if range is 'all'
        end_point = "/accounts/#{account_id}/products/#{app_id}/sales"
      else 
        end_point = "/accounts/#{account_id}/products/#{app_id}/sales?break_down=date&start_date=#{start_date}&end_date=#{end_date}"

      msg.http(api_path + end_point)
        .headers(Authorization: api_token, Accept: 'application/json')
        .get() (err, res, body) ->
          data = JSON.parse body
          messages = []
          for sales in data.sales_list
            messages.push "#{sales.date} : #{sales.units.product.downloads}"
          msg.send messages.join("\n")
    else
      msg.send 'Platform must be specified "android" or "ios"'
