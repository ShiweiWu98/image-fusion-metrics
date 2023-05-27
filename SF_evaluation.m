function SF = SF_evaluation(grayImage)
    grayImage=double(grayImage);
    [rows,cols]=size(grayImage);
    tempA=0;tempB=0;
    for i=1:rows 
        for j=2:cols
            temp=(grayImage(i,j)-grayImage(i,j-1))^2;
            tempA=tempA+temp;
        end
    end
    for j=1:cols 
        for i=2:rows
            temp=(grayImage(i,j)-grayImage(i-1,j))^2;
            tempA=tempA+temp;
        end
    end
    RF=(1/(rows*cols))*tempA;
    CF=(1/(rows*cols))*tempB;
    SF=(RF+CF)^0.5;
end
