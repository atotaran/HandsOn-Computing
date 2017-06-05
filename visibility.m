function visibility(p,t2,t3,t2c,t3c,spring1,spring2,t12,rs,i,N,condition)
%This function Sets up the visibility of the graphical elements depending
%on the condition
if condition==0
    for i=1:N
        p(i).s.Visible='off';
        p(i).s2.Visible='on';
        p(i).m.Visible='off';
    end
elseif condition==1
    t2.Visible='on';
    t3.Visible='on';
    t2c.Visible='on';
    t3c.Visible='on';
    spring1.Visible='off';
    spring2.Visible='off';
elseif condition==2
    p(i).s.Visible='on';
    p(i+1).s.Visible='on';
    p(i).m.Visible='on';
    p(i+1).m.Visible='on';
    p(i).s2.Visible='off';
    p(i+1).s2.Visible='off';
elseif condition==3
    t12.Visible='off';
    t2.Visible='off';
    t3.Visible='off';
    t2c.Visible='off';
    t3c.Visible='off';
    spring1.Visible='on';
    spring2.Visible='on';
    rs(1).r.Visible='off';
    rs(2).r.Visible='off';
elseif condition==4
    p(i).s.Visible='off';
    p(i+1).s.Visible='off';
    p(i).m.Visible='off';
    p(i+1).m.Visible='off';
    p(i).s2.Visible='on';
    p(i+1).s2.Visible='on';
elseif condition==5
    for i=1:N
        p(i).s.Visible='on';
        p(i).s2.Visible='off';
        p(i).m.Visible='on';
    end
    for i=1:2
        rs(i).r.Visible='off';
    end
elseif condition==6
    t12.Visible='off';
    t2.Visible='off';
    t3.Visible='off';
    t2c.Visible='off';
    t3c.Visible='off';
    spring1.Visible='on';
    spring2.Visible='on';
    rs(1).r.Visible='off';
    rs(2).r.Visible='off';
elseif condition==7
    p(i).s.Visible='on';
    p(i).m.Visible='on';
    p(i).s2.Visible='off';
    t12.Visible='off';
    t2.Visible='off';
    t3.Visible='off';
    t2c.Visible='off';
    t3c.Visible='off';
    spring1.Visible='on';
    spring2.Visible='on';
elseif condition==8
    t12.Visible='off';
    t2.Visible='off';
    t3.Visible='off';
    t2c.Visible='off';
    t3c.Visible='off';
    spring1.Visible='on';
    spring2.Visible='on';
else
    msgbox('WRONG VISIBILITY CONDITION');
end
drawnow