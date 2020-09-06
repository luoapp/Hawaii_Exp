function a=soundspeed(t,s)
%function a=soundspeed(t,s)
%
%get sound speed given temperature t and salinity s
a=1449+(4.6*t)+(-.055*t.^2)+(.0003*t.^3)+(1.39-.012*t).*(s-35);