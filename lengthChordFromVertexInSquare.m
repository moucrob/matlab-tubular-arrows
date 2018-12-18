function length = lengthChordFromVertexInSquare(angle,squareSize)
if angle < 0 || angle > 90   
    error('lengthChordFromVertexInSquare() is designed such that the inputed angle goes from 0 to 90° only!');     
end
%        chord
% ________________
% |      /        |
% |     /         |
% |    /          |
% |   /           |
% |  /\           |
% | /  \ angle    |
% |/____|_________|         

c = cos(deg2rad(angle)) ; s = sin(deg2rad(angle));
%inspired by https://stackoverflow.com/questions/1343346/calculate-a-vector-from-the-center-of-a-square-to-edge-based-on-radius
if angle <= 45
	magnitud= squareSize/c; %(cos(pi/4)=1/sqrt(2) which leads to squareSize*sqrt(2), ok!)
else
    magnitud= squareSize/s;
end

length = norm(magnitud*[c,s]);
end