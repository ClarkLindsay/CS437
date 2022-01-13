#!/usr/bin/env python3

####################################
### Clark Lindsay - SIU854268267 ###
#####     November 4th 2021   ######
####################################

# Get user input for sharp temperature and weight
t = float(input("Air temperature: "))
w = float(input("Clothing weight: "))

# Set degree of membership for cold based on temperature input
if t <= 70:
    deg_cold_t = 1
elif 70 < t < 80:
    deg_cold_t = (80 - t)/(80 - 70)
elif t >= 80:
    deg_cold_t = 0

# Set degree of membership for medium based on temperature input
if t <= 70:
    deg_medium_t = 0
elif 70 < t < 80:
    deg_medium_t = (t - 70)/(80 - 70)
elif 80 <= t <= 100:
    deg_medium_t = 1
elif 100 < t < 140:
    deg_medium_t = (140 - t)/(140 - 100)
elif t >= 140:
    deg_medium_t = 0

# Set degree of membership for hot based on temperature input
if t <= 120:
    deg_hot_t = 0
elif 120 < t < 140:
    deg_hot_t = (t - 120)/(140 - 120)
elif 140 <= t <= 150:
    deg_hot_t = 1
elif 150 < t < 160:
    deg_hot_t = (160 - t)/(160 - 150)
elif t >= 160:
    deg_hot_t = 0

# Set degree of membership for very hot based on temperature input
if t <= 150:
    deg_vhot_t = 0
elif 150 < t < 160:
    deg_vhot_t = (160 - t)/(160 - 150)
elif t >= 160:
    deg_vhot_t = 1

# Set degree of membership for light based on weight input
if w <= 5:
    deg_light_w = 1
elif 5 < w < 10:
    deg_light_w = (10 - w)/(10 - 5)
elif w >= 10:
    deg_light_w = 0

# Set degree of membership for average based on weight input
if w <= 5:
    deg_average_w = 0
elif 5 < w < 10:
    deg_average_w = (w - 5)/(10 - 5)
elif 10 <= w <= 15:
    deg_average_w = 1
elif 15 < w < 20:
    deg_average_w= (20 - w)/(20 - 15)
elif w >= 20:
    deg_average_w = 0

# Set degree of membership for heavy based on weight input
if w <= 15:
    deg_heavy_w = 0
elif 15 < w < 20:
    deg_heavy_w = (w - 15)/(20 - 15)
elif w >= 20:
    deg_heavy_w = 1

# Fuzzy rules
deg_medium_v = max(min(deg_cold_t, deg_light_w), min(deg_medium_t, deg_average_w), min(deg_hot_t, deg_average_w), min(deg_hot_t, deg_heavy_w))
deg_mhigh_v = max(min(deg_cold_t, deg_average_w), min(deg_medium_t, deg_heavy_w))
deg_high_v = min(deg_cold_t, deg_heavy_w)
deg_mlow_v = max(min(deg_medium_t, deg_light_w), min(deg_vhot_t, deg_heavy_w))
deg_low_v = max(min(deg_hot_t, deg_light_w), min(deg_vhot_t, deg_light_w), min(deg_vhot_t, deg_average_w))

klow = (70+90+100)/3
kmlow =  (100+120+140)/3
km = (150+170+190)/3
kmhigh = (180+200+220)/3
khigh =  (220+240+240)/3

v = (deg_low_v*klow + deg_mlow_v*kmlow + deg_medium_v*km + deg_mhigh_v*kmhigh +
    deg_high_v*khigh) / (deg_low_v + deg_mlow_v + deg_medium_v + deg_mhigh_v + deg_high_v)

print("Heating coil voltage: " + str('%.2f'%(v)))
