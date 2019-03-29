# Final Project
# Author: Chizhi Xia, Tieyong Yu

2019.03.20: 
Purpose and primary features
Our app named “CouponGo”, aims to making the business activity of spreading coupons with AR techniques, which replaces common paper coupon with digital coupon and makes the process of getting coupon has more fun.
This app has its initial two purposes, one is to make coupon more useful, since we often get coupons when we don’t need, and next time when we want to use it we cannot find it. This app stores digital coupons for users, in addition, it makes user to grab coupon nearby the restaurant, thus user can use coupons immediately after grabbed it. Another purpose is to allow the process of getting coupons with more fun, and also promote users to go out to grab coupon when he/she is near the restaurant, which makes them more likely to use coupon and make assumption at restaurant.

Categorties: Food & Drink (primary), Business (Secondary)
Description: This is an app allowing you to get coupons when you want to eat at restaurant. Don’t worry if you forget any coupon, it’s your personal digital wallet of coupons. The coupons are not that easy to get, you need to find it carefully. Take your iphone, go grabbing coupons with much fun in it!
Keywords: Coupon, AR, map, restaurant, camera, search, food, location ScreenShots:

Primary features:
1. Show map at user’s location, and show both restaurant and coupon labels on the map. (GoogleAPI, YelpAPI).
2. Show a camera view when user wants to grab the coupon, and put the 3D coupon at a random spatial position, only when user (with iphone) comes to the nearby of this coupon (within the distane of 1 meter) can he/she get that coupon.

Using tips
Setting up:
1. This app can only be tested on real iphone since it asks to use camera.
2. Please do "Product->Clean Builde Folder" for the first time run.
3. make sure you have a unique bundle identifier, maybe appending a number
behind.
4. make sure you select the correct local developer for "team".
    
Begin journey:
1. In the main page (Google API), you can search for restaurants, also click on the little circle or square box to see its brief introduction on markers. The navigation button in the bottomleft allows you to come back to your location.
2. When click on restaurant marker, it shows the detail information for that restaurant within yelp API.
3. When click on coupon marker, it goes to camera view and follow the instruction to find the white box inside the view and grab it by clicking the “Get” button.
4. Switch tabbar to the wallet, and a collection view displays all the grabbed and
unused coupons, when click on the coupon, it shows detail of usage and expire time for coupon, also by clicking the “use” button to see its code.
       Competitive features
This app is based on a fancy idea, which changes the traditional way of getting coupons by embedding it in an ARView. For users, we can have more fun during the process of receiving the coupon. And for restaurants, they can appeal more potential customers, since when user grabbed the coupon means they are already nearby.
Future plan
For future version, the first thing we want to improve is the AR part, where we can change the white cube to a 3D coupon icon, and add more interaction between the AR object and the users, with a more complicate rule.
