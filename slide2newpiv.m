function slide2newpiv(rs,piv,oldp,newp,hndl, s, bpos)
%This function is for moving the graphical indicators of the pivot to the right place for the insertion sort algorithm 
xbox=rs(2).r.Position(1);
xpiv=piv.Position(1);
M=20;
for k=1/M:1/M:1
    slideBox(rs,piv,xbox,xpiv,k,newp-oldp);
    [bpos, com_error]=handleupdate(hndl, s, bpos);
    drawnow
end
end

function rs=slideBox(rs,piv,xbox,xpiv,k,incr)
x1=xbox*(1-k)+(xbox+incr)*k;
rs(2).r.Position(1)=x1;
x2=xpiv*(1-k)+(xpiv+incr)*k;
piv.Position(1)=x2;
end