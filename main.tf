terraform {
  required_providers {
    datadog = {
      source = "DataDog/datadog"
    }
  }
}

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
}

resource "datadog_synthetics_global_variable" "wam_username" {
  name        = "PLAYBYPOINT_USERNAME"
  description = "Username to wam.playbypoint.com"
  value       = var.wam_username
}

resource "datadog_synthetics_global_variable" "wam_password" {
  name        = "PLAYBYPOINT_PASSWORD"
  description = "Password to wam.playbypoint.com"
  value       = var.wam_password
  secure      = true
}

resource "datadog_synthetics_test" "book_court" {
  type = "browser"

  request_definition {
    method = "GET"
    url    = "https://wam.playbypoint.com"
  }

  device_ids = ["chrome.laptop_large"]
  locations  = ["aws:us-west-2"]

  options_list {
    tick_every = 86400
  }

  name = "wam.playbypoint.com Court Reservation"
  status = "paused"

  browser_variable {
    type    = "global"
    name    = "PLAYBYPOINT_USERNAME"
    id      = datadog_synthetics_global_variable.wam_username.id
  }

  browser_variable {
    type    = "global"
    name    = "PLAYBYPOINT_PASSWORD"
    id      = datadog_synthetics_global_variable.wam_username.id
  }

  browser_variable {
    type    = "text"
    name    = "LAST_DAY_SELECTOR"
    pattern = ".over_flex_mobile_button_container.more_height .flex_mobile_button_container .button:last-child"
    example = ".over_flex_mobile_button_container.more_height .flex_mobile_button_container .button:last-child"
  }

  browser_variable {
    type    = "text"
    name    = "FIRST_AVAILABLE_TIME_SELECTOR"
    pattern = "button.ButtonOption.ui.button.basic.with_group.firstOfGroup:first-child"
    example = "button.ButtonOption.ui.button.basic.with_group.firstOfGroup:first-child"
  }

  browser_variable {
    type    = "text"
    name    = "COURT_TIME_545_7PM_XPATH_SELECTOR"
    pattern = "//button[text()[contains(.,'5:45-7pm')]]"
    example = "//button[text()[contains(.,'5:45-7pm')]]"
  }

  browser_step {
    name = "Click on link \"Login\""
    type = "click"
    params {
      element = jsonencode({
            "url": "https://wam.playbypoint.com/",
            "targetOuterHTML": "<a class=\"ui button flat page_font capitalize\" href=\"/users/sign_in\">Login</a>",
            "multiLocator": {
              "ab": "/*[local-name()=\"html\"][1]/*[local-name()=\"body\"][1]/*[local-name()=\"div\"][1]/*[local-name()=\"div\"][1]/*[local-name()=\"header\"][1]/*[local-name()=\"div\"][1]/*[local-name()=\"div\"][1]/*[local-name()=\"div\"][1]/*[local-name()=\"div\"][3]/*[local-name()=\"a\"][1]",
              "co": "[{\"text\":\"login\",\"textType\":\"directText\"},{\"relation\":\"PARENT OF\",\"tagName\":\"DIV\",\"text\":\"all courts playable\",\"textType\":\"innerText\"}]",
              "cl": "/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \" flat \")]",
              "at": "",
              "clt": "/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \" flat \")]",
              "ro": "//*[contains(concat(' ', normalize-space(@class), ' '), \" ui \") and contains(concat(' ', normalize-space(@class), ' '), \" button \") and contains(concat(' ', normalize-space(@class), ' '), \" flat \") and contains(concat(' ', normalize-space(@class), ' '), \" page_font \") and contains(concat(' ', normalize-space(@class), ' '), \" capitalize \")]"
            }
        })
    }
  }

  browser_step {
    name = "Type text on input #user_email"
    type = "typeText"
    params {
      value = "{{ PLAYBYPOINT_USERNAME }}"
      element = jsonencode({
            "url": "https://wam.playbypoint.com/users/sign_in",
            "targetOuterHTML": "<input class=\"string email optional\" autofocus=\"autofocus\" placeholder=\"Email\" type=\"email\" value=\"\" name=\"user[email]\" id=\"user_email\">",
            "multiLocator": {
              "ab": "/*[local-name()=\"html\"][1]/*[local-name()=\"body\"][1]/*[local-name()=\"div\"][1]/*[local-name()=\"div\"][2]/*[local-name()=\"div\"][1]/*[local-name()=\"div\"][2]/*[local-name()=\"div\"][1]/*[local-name()=\"div\"][2]/*[local-name()=\"form\"][1]/*[local-name()=\"div\"][1]/*[local-name()=\"div\"][1]/*[local-name()=\"div\"][1]/*[local-name()=\"input\"][1]",
              "co": "[{\"text\":\"email\",\"textType\":\"innerText\"}]",
              "cl": "/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \" string \")]",
              "at": "/descendant::*[@name=\"user[email]\" and @value=\"\"]",
              "clt": "/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \" string \")]",
              "ro": "//*[@id=\"user_email\"]"
            }
        })
    }
  }

  browser_step {
    name = "Type text on input #user_password"
    type = "typeText"
    params {
      value = "{{ PLAYBYPOINT_PASSWORD }}"
      element = jsonencode({
            "url": "https://wam.playbypoint.com/users/sign_in",
            "targetOuterHTML": "<input class=\"password optional\" placeholder=\"Password\" type=\"password\" name=\"user[password]\" id=\"user_password\">",
            "multiLocator": {
              "ab": "/*[local-name()=\"html\"][1]/*[local-name()=\"body\"][1]/*[local-name()=\"div\"][1]/*[local-name()=\"div\"][2]/*[local-name()=\"div\"][1]/*[local-name()=\"div\"][2]/*[local-name()=\"div\"][1]/*[local-name()=\"div\"][2]/*[local-name()=\"form\"][1]/*[local-name()=\"div\"][1]/*[local-name()=\"div\"][1]/*[local-name()=\"div\"][2]/*[local-name()=\"input\"][1]",
              "co": "[{\"text\":\"password\",\"textType\":\"innerText\"}]",
              "cl": "/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \" mb0 \")]/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \" optional \")][1]",
              "at": "/descendant::*[@name=\"user[password]\" and @placeholder=\"Password\"]",
              "clt": "/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \" mb0 \")]/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \" optional \")][1]",
              "ro": "//*[@id=\"user_password\"]"
            }
        })
    }
  }

  browser_step {
    name = "Click on input \"commit\""
    type = "click"
    params {
      element = jsonencode({
            "url": "https://wam.playbypoint.com/users/sign_in",
            "targetOuterHTML": "<input type=\"submit\" name=\"commit\" value=\"Log in\" class=\"ui button green gradient ui button fluid\" data-disable-with=\"Log in\">",
            "multiLocator": {
              "ab": "/*[local-name()=\"html\"][1]/*[local-name()=\"body\"][1]/*[local-name()=\"div\"][1]/*[local-name()=\"div\"][2]/*[local-name()=\"div\"][1]/*[local-name()=\"div\"][2]/*[local-name()=\"div\"][1]/*[local-name()=\"div\"][2]/*[local-name()=\"form\"][1]/*[local-name()=\"div\"][1]/*[local-name()=\"div\"][1]/*[local-name()=\"div\"][4]/*[local-name()=\"input\"][1]",
              "co": "",
              "cl": "/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \" button \")]",
              "at": "/descendant::*[@name=\"commit\" and @value=\"Log in\"]",
              "clt": "/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \" button \")]",
              "ro": "//*[@name=\"commit\"]"
            }
        })
    }
  }

  browser_step {
    name = "Click on span \"Book Now\""
    type = "click"
    params {
      element = jsonencode({
            "url": "https://wam.playbypoint.com/home",
            "targetOuterHTML": "<span class=\"text bold green\"> Book Now </span>",
            "multiLocator": {
              "ab": "/*[local-name()=\"html\"][1]/*[local-name()=\"body\"][1]/*[local-name()=\"div\"][1]/*[local-name()=\"div\"][2]/*[local-name()=\"div\"][2]/*[local-name()=\"div\"][1]/*[local-name()=\"div\"][2]/*[local-name()=\"div\"][3]/*[local-name()=\"div\"][1]/*[local-name()=\"div\"][1]/*[local-name()=\"div\"][1]/*[local-name()=\"div\"][1]/*[local-name()=\"div\"][2]/*[local-name()=\"a\"][1]/*[local-name()=\"span\"][1]",
              "co": "[{\"text\":\"book now\",\"textType\":\"directText\"}]",
              "cl": "/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \" bold \") and contains(concat(' ', normalize-space(@class), ' '), \" green \")]",
              "at": "",
              "clt": "/descendant::*[contains(concat(' ', normalize-space(@class), ' '), \" bold \") and contains(concat(' ', normalize-space(@class), ' '), \" green \")]",
              "ro": "//*[text()[normalize-space(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞŸŽŠŒ', 'abcdefghijklmnopqrstuvwxyzàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿžšœ')) = \"book now\"]]"
            }
        })
    }
  }
}
