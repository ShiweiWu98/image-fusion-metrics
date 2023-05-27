function cc = CC_evalution(vis,ir,fused)
    N1=sum(sum((ir-mean(mean(ir))).*(fused-mean(mean(fused)))));
    D1=sqrt(sum(sum((ir-mean(mean(ir))).^2))*sum(sum((fused-mean(mean(fused))).^2)));
    r_AF=N1/D1;
    N2=sum(sum((vis-mean(mean(vis))).*(fused-mean(mean(fused)))));
    D2=sqrt(sum(sum((vis-mean(mean(vis))).^2))*sum(sum((fused-mean(mean(fused))).^2)));
    r_BF=N2/D2;
    cc=0.5*r_AF+0.5*r_BF;
end