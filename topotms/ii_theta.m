function theta = ii_theta(a)
%Calculates Angles of a Triangle from Vertices in the form (x y) from input
%a.

x=a(:,1);
y=a(:,2);
tri=delaunay(x,y);
tri=sortrows(tri);
triplot(tri,x,y)

for i = 1 : size(tri,1)
    
    V1 = a(tri(i,1),:);
    V2 = a(tri(i,2),:);
    V3 = a(tri(i,3),:);
    
    A1 = atan2(abs(det([V2-V1;V3-V1])),dot(V2-V1,V3-V1))/pi*180;
    A2 = atan2(abs(det([V3-V2;V1-V2])),dot(V3-V2,V1-V2))/pi*180;
    A3 = atan2(abs(det([V1-V3;V2-V3])),dot(V1-V3,V2-V3))/pi*180;
    theta(i,:) = [ A1 A2 A3 ];
    A1 + A2 + A3;
end

end

