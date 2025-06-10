# Pin npm packages by running ./bin/importmap

pin "application"
pin "user_menu"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin "chart.js", to: "https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@rails/ujs", to: "rails-ujs.js"



