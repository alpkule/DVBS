function  [b] = dvbs_shaping_filter()
b=rcosdesign(0.35, 4, 2, 'sqrt'); %1 4