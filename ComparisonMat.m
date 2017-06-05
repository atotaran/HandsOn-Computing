function CompMatrix=ComparisonMat(x,mode)
switch mode
    case 1
        CompMatrix=bubblecomp(x);
    case 2
        CompMatrix=insertcomp(x);
end
end

function CompMatrix=bubblecomp(x)
N = length(x);
CompMatrix=zeros(4*N,3);
cmp=0;
while (N > 0)
    N2 = 0;
    for i = 1:N-1
        cmp=cmp+1;
        % Swap elements in wrong order
        CompMatrix(cmp,1:2)=[i i+1];
        if (x(i) > x(i + 1))
            x = swap(x,i,i + 1);
            N2 = i;
            CompMatrix(cmp,3)=1;
        else
            CompMatrix(cmp,3)=0;
        end
    end
    N = N2;
end
disp(x);
CompMatrix=CompMatrix(1:cmp,:);
end
function CompMatrix=insertcomp(x)
N = length(x);
CompMatrix=zeros(4*N,3);
cmp=0;
for j = 2:N
    pivot = x(j);
    i = j;
    while i > 1
        cmp=cmp+1;
        CompMatrix(cmp,1:2)=[i-1 i];
        disp(x)
        disp([i-1 i])
        if x(i - 1) > pivot
            x(i) = x(i - 1);
            i = i - 1;
            CompMatrix(cmp,3)=1;
        else
            CompMatrix(cmp,3)=0;
            break;
        end
    end
    x(i) = pivot;
end
disp(x);
CompMatrix=CompMatrix(1:cmp,:);
end
function x = swap(x,i,j)
% Swap x(i) and x(j)
% Note: In practice, x xhould be passed by reference

val = x(i);
x(i) = x(j);
x(j) = val;

end