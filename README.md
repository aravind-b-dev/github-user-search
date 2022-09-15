# GITHUB API INTEGRATION

Create an android application which uses github api, the android app should have an interface in
which the user can search for username. The result page should show 2 tabs, i.e. profile and
repositories

1. Profile Tab
   - Show profile image
   - Brief summary of searched user
   - No of repositories
2. Repository Tab
   - Should show list of all repositories
   - Show have a filter for repository filtering
   - Upon clicking the repository, the repo should open in a custom chrome tab

Screen Shots

![landing](https://user-images.githubusercontent.com/73890321/190368431-566eadef-a800-4ac3-a2ad-523dcc651f98.jpg)
![profiletab](https://user-images.githubusercontent.com/73890321/190368846-ad17bc5a-8d59-4198-b2e4-8d9b584ffbf7.jpg)
![repotab](https://user-images.githubusercontent.com/73890321/190368886-02c79ad9-32b2-45cb-85c0-22917299d315.jpg)
![nointernet](https://user-images.githubusercontent.com/73890321/190368943-05a47c50-eec2-41f0-a67e-17a6c6976ea7.jpg)

Sceeen Video


https://user-images.githubusercontent.com/73890321/190369983-efcbaa24-201b-4345-b42e-dbb291afb67f.mp4

--------------------------------------------

Steps that i followed 

Flutter version - 2.5.0

App constructed this project using Provider State management. 
provider: ^6.0.2

uses http request to access and use the rest api data
http: ^0.13.5

url_launcher is used to open repository in chrome tab
url_launcher: ^6.0.9

to handle no internet connection connectivity_plus is used
connectivity_plus: ^2.2.0

---------------------------------------------

App work flow

After running the app, user have to enter the username on a textfield and click on the search button. After submitting user will redirected into two tabs. Onr tab will contain Username, User profile picture, bio and total no of respositories. And the tab contain reposiotry details. Also provide a redirect link to the github repo.



app-release.apk file included
assets/apk/app-release.apk




