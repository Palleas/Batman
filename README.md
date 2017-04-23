# Batman [![BuddyBuild](https://dashboard.buddybuild.com/api/statusImage?appID=58ee2ca2e9e4f000013abe3b&branch=master&build=latest)](https://dashboard.buddybuild.com/apps/58ee2ca2e9e4f000013abe3b/build/latest?branch=master)

Batman is an iOS app to create tasks in [Asana](http://asana.com).

## Installation

Using [buddybuild](http://buddybuild.com):

1. Fork this repo
2. Onboard the app in [buddybuild](http://buddybuild.com)
3. Add a **ASANA_TOKEN** device key with [your token](https://asana.com/developers/documentation/getting-started/auth#personal-access-token)
4. Build and deploy the app on your device

Locally

1. Clone this repo
2. `make update` 
3. Add a **ASANA_TOKEN** environment variable in the Batman scheme with [your token](https://asana.com/developers/documentation/getting-started/auth#personal-access-token)
4. Run the app

## Why

We use Asana at [buddybuild](http://buddybuild.com) and I wanted a quick way to create a task from my phone. I know that Asana already has [an iOS app](https://itunes.apple.com/ca/app/asana-team-tasks-conversations/id489969512?mt=8) but I wanted to make something that allows me to create tasks super quickly. Also, it's fun.

## License

[MIT](LICENSE)
