%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The standard deviation (STD)
function SD = SD_evaluation(img)
img = im2double(img);
[row,clom] = size(img);
% mean
u = sum(sum(img))/(row*clom);
sumSD = 0;
for i=1:row
    for j=1:clom
        sumSD = (img(i,j)-u)^2+sumSD;
    end
end
SD = sqrt(sumSD);
end
