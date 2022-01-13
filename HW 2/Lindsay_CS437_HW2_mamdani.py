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

# Find the areas and centroids of each voltage membership function
vlow1 = 70 + deg_low_v*(90 - 70)
area_low1 = 0.5*deg_low_v*(vlow1-70)
centroid_low1 = (70+vlow1+vlow1)/3

vlow3 = 100 - deg_low_v*(100 - 90)
area_low3 = 0.5*deg_low_v*(100-vlow3)
centroid_low3 = (vlow3+vlow3+100)/3

area_low2 = deg_low_v*(vlow3 - vlow1)
centroid_low2 = (vlow1+vlow3)/2



vmlow1 = 100 + deg_mlow_v*(120 - 100)
area_mlow1 = 0.5*deg_mlow_v*(vmlow1-100)
centroid_mlow1 = (100+vmlow1+vmlow1)/3

vmlow3 = 140 - deg_mlow_v*(140 - 120)
area_mlow3 = 0.5*deg_mlow_v*(140-vmlow3)
centroid_mlow3 = (vmlow3+vmlow3+140)/3

area_mlow2 = deg_mlow_v*(vmlow3 - vmlow1)
centroid_mlow2 = (vmlow1+vmlow3)/2



vm1 = 150 + deg_medium_v*(170 - 150)
area_m1 = 0.5*deg_medium_v*(vm1-150)
centroid_m1 = (150+vm1+vm1)/3

vm3 = 190 - deg_medium_v*(190 - 170)
area_m3 = 0.5*deg_medium_v*(190-vm3)
centroid_m3 = (vm3+vm3+190)/3

area_m2 = deg_medium_v*(vm3 - vm1)
centroid_m2 = (vm1+vm3)/2



vmhigh1 = 180 + deg_mhigh_v*(200 - 180)
area_mhigh1 = 0.5*deg_mhigh_v*(vmhigh1-180)
centroid_mhigh1 = (180+vmhigh1+vmhigh1)/3

vmhigh3 = 220 - deg_mhigh_v*(220 - 200)
area_mhigh3 = 0.5*deg_mhigh_v*(220-vmhigh3)
centroid_mhigh3 = (vmhigh3+vmhigh3+220)/3

area_mhigh2 = deg_mhigh_v*(vmhigh3 - vmhigh1)
centroid_mhigh2 = (vmhigh1+vmhigh3)/2



vhigh1 = 220 + deg_high_v*(240 - 220)
area_high1 = 0.5*deg_high_v*(vhigh1-220)
centroid_high1 = (220+vhigh1+vhigh1)/3

area_high2 = deg_high_v*(240 - vhigh1)
centroid_high2 = (vhigh1+240)/2

# Calculate the COG of the aggregate output
v = (area_low1*centroid_low1 + area_low2*centroid_low2 + area_low3*centroid_low3 +
    area_mlow1*centroid_mlow1 + area_mlow2*centroid_mlow2 + area_mlow3*centroid_mlow3 +
    area_m1*centroid_m1 + area_m2*centroid_m2 + area_m3*centroid_m3 +
    area_mhigh1*centroid_mhigh1 + area_mhigh2*centroid_mhigh2 + area_mhigh3*centroid_mhigh3 +
    area_high1*centroid_high1 + area_high2*centroid_high2) / (area_low1 + area_low2 + area_low3 +
    area_mlow1 + area_mlow2 + area_mlow3 + area_m1 + area_m2 + area_m3 +
    area_mhigh1 + area_mhigh2 + area_mhigh3 + area_high1 + area_high2)

print("Heating coil voltage: " + str('%.2f'%(v)))
