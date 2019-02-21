function tf = isEC2()
% ISEC2 returns true if running on AWS EC2 otherwise returns false

%                 (c) 2017 MathWorks, Inc.
%                 $Id$

persistent pIsEC2
if isempty(pIsEC2)
    % Regions
    import com.amazonaws.regions.Region
    import com.amazonaws.regions.Regions
    
    % if not running on EC2 this call should return a null
    ec2Region = Regions.getCurrentRegion();
    
    if isempty(ec2Region)
        pIsEC2 = false;
    else
        pIsEC2 = true;
    end
end

tf = pIsEC2;

end
