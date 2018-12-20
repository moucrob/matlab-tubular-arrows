function arrowHandle = arrow3D(pos, deltaValues, colorCode, stemRatio, cylRad )

% arrowHandle = arrow3D(pos, deltaValues, colorCode, stemRatio) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%     Used to plot a single 3D arrow with a cylindrical stem and cone arrowhead
%     pos = [X,Y,Z] - spatial location of the starting point of the arrow (end of stem)
%     deltaValues = [QX,QY,QZ] - delta parameters denoting the magnitude of the arrow along the x,y,z-axes (relative to 'pos')
%     colorCode - Color parameters as per the 'surf' command.  For example, 'r', 'red', [1 0 0] are all examples of a red-colored arrow
%     stemRatio - The ratio of the length of the stem in proportion to the arrowhead.  For example, a call of:
%                 arrow3D([0,0,0], [100,0,0] , 'r', 0.82) will produce a red arrow of magnitude 100, with the arrowstem spanning a distance
%                 of 82 (note 0.82 ratio of length 100) while the arrowhead (cone) spans 18.  
% 
%     Example:
%       arrow3D([0,0,0], [4,3,7]);  %---- arrow with default parameters
%       axis equal;
% 
%    Author: Shawn Arseneau
%    Created: September 14, 2006
%    Updated: September 18, 2006
%
%    Updated: December 20, 2018
%       Tlab - refactored to have only one surface object as ouput
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if nargin<2 || nargin>6    
        error('Incorrect number of inputs to arrow3D');     
    end
    if numel(pos)~=3 || numel(deltaValues)~=3
        error('pos and/or deltaValues is incorrect dimensions (should be three)');
    end
    if nargin<3                 
        colorCode = 'interp';                               
    end
    if nargin<4                 
        stemRatio = 0.75;                                   
    end    
    Ncol = 21 ; % default number of column for the "cylinder.m" function

    X = pos(1); %---- with this notation, there is no need to transpose if the user has chosen a row vs col vector
    Y = pos(2);
    Z = pos(3);

    [~, ~, srho] = cart2sph(deltaValues(1), deltaValues(2), deltaValues(3));  

    %******************************************* CYLINDER == STEM *********************************************
    cylinderRadius = cylRad;
    cylinderLength = srho*stemRatio;
    [CX,CY,CZ] = cylinder(cylinderRadius,Ncol-1);
    CZ = CZ.*cylinderLength;    %---- lengthen

     %******************************************* CONE == ARROWHEAD *********************************************
    coneLength = srho*(1-stemRatio);
    [coneX, coneY, coneZ] = cylinder([cylinderRadius*2 0],Ncol-1);  %---------- CONE 
    coneZ = coneZ.*coneLength;
    % Translate cone on top of the stem cylinder
    coneZ = coneZ + cylinderLength ;

    % now close the bottom and add the cone to the stem cylinder surface
    bottom = zeros(1,Ncol) ;
    CX = [ bottom ; CX ; coneX ] ;
    CY = [ bottom ; CY ; coneY ] ;
    CZ = [ bottom ; CZ ; coneZ ] ;

    Nrow = size(CX,1);


    %----- ROTATE
    %---- initial rotation to coincide with X-axis
    newEll = rotatePoints([0 0 -1], [CX(:), CY(:), CZ(:)]); %CX(:) actually reshape the 2xN matrices in a 2N vert vector, by vertically concatenating each column
    CX = reshape(newEll(:,1), Nrow, Ncol);
    CY = reshape(newEll(:,2), Nrow, Ncol);
    CZ = reshape(newEll(:,3), Nrow, Ncol);

    newEll = rotatePoints(deltaValues, [CX(:), CY(:), CZ(:)]);
    stemX = reshape(newEll(:,1), Nrow, Ncol);
    stemY = reshape(newEll(:,2), Nrow, Ncol);
    stemZ = reshape(newEll(:,3), Nrow, Ncol);

    %----- TRANSLATE
    stemX = stemX + X;
    stemY = stemY + Y;
    stemZ = stemZ + Z;

    %----- DISPLAY
    hStem = surf(stemX, stemY, stemZ, 'FaceColor', colorCode, 'EdgeColor', 'none');

    %----- DISPLAY
    if nargout==1   
        arrowHandle = hStem ; 
    end