function [bpos, com_error]=handleupdate(h, s, bpos)
            com_error=false;
            if s.BytesAvailable
                [data, com_error]=serread(s);
                            bpos=-1*double(data(2))/600;
            h(1).s.XData=h(1).x+ones(1,6)*bpos;
            h(2).s.Position=h(2).x+[bpos 0 0 0];
            h(3).s.Position=h(3).x+[bpos 0 0 0];
            end
end