clc;close all; clear all;

dimensionality = 80; %number of neurons
halfdim = dimensionality/2;
time = 50; %time unit
upperLimit = 60; %maximum firing rate
lowerLimit = 0; %minimum firing rate
epsilon = .1; 

%distance matrix containing distance information for all neurons
for i=1:dimensionality 
    for j=1:dimensionality 
         dist = abs(i-j);
         if dist > halfdim
            dist = mod(-dist,dimensionality);
         end
         distMat(i,j) = dist;
    end
end


length_constant = 2; 
name1 = {'Figure 4.19','Figure 4.20','Figure 4.21','Figure 4.22','Figure 4.23'};
figIndex = 1;
for maxInhibition = [0.1 0.2 0.5 1 2]
    
   
    initialState = zeros(dimensionality,1); 

    
    weightMatrix = zeros(dimensionality,dimensionality);

    %instantiate initial state
    for iter=1:dimensionality
        for i=1:20
            initialState(i,1)=10;
        end
        for i=21:60
            initialState(i,1)=40;
        end
        for i=61:dimensionality
            initialState(i,1)=10;
        end
    end
    
    stateVec = initialState; 

    figure;
    x=initialState;
    y=1:dimensionality;
    plot(x,y,'+'); %plot initial state
    
    %figure formats to replicate textbook figures
    set(gca, 'XAxisLocation', 'top')
    set(gca,'ydir','reverse')
    xlabel('Firing rate: Spikes/second')
    ylabel('neuron')
    axis([0 50,12 30])
    title(strcat(name1{figIndex},'| Length Constant= ',num2str(length_constant),'| Maximum Inhibition= ', num2str(maxInhibition)));
    figIndex = figIndex + 1;%update figure index for the next figure



    %instantiate connection weights based on distance between neurons 
    for i=1:dimensionality
        for j=1:dimensionality
            dist = distMat(i,j);
            weightMatrix(i,j) = -(maxInhibition*exp(-(dist/length_constant)));%formula from lecture & textbook     
        end
    end
    
    %apply weights to neurons across time
    for t=1:time 
        previousState = stateVec;
        deltaF = initialState + weightMatrix*previousState - previousState;%delta f formula
        stateVec = stateVec + epsilon*deltaF;
        
        %if firing rate of a neuron is outside the boundary (0 to 60
        %spikes/second), then set the value to nearest boundary value.
        stateVec(stateVec<lowerLimit) = lowerLimit;
        stateVec(stateVec>upperLimit) = upperLimit;
    end
   4
    hold on;
    x=stateVec;
    y=1:dimensionality; 
    plot(x,y,'*'); %plot final state
    legend({'Initial State', 'Final State'});
    hold off;

end



%###################################winner take all####################



length_constant = 10;%higher length constant allows us to apply lateral inhibition to larger areas to accomplish winnter take all sysyem.
stepsize = 10;%used for setting up initial state
name2 = {'Figure 4.26','Figure 4.27','Figure 4.28','Figure 4.29'};
figIndex = 1;

for maxInhibition = [1 1 1 2]
    
    initialState = zeros(dimensionality,1);
    
    %initial state is different depending on different figures
    if figIndex == 1
        base = 0;%base firing rate for neurons
        for k=1:dimensionality
            for i=1:15
                initialState(i,1)= base;
            end
            for i=1:5
               initialState(15+i,1)= stepsize*i;
            end
            for i=1:4
                initialState(20+i,1)= 50-stepsize*i;
            end
            for i=25:80
                initialState(i,1)=base;
            end
        end
    else if figIndex == 2
        base = 10;
        for k=1:dimensionality
            for i=1:15
                initialState(i,1)= base;
            end
            for i=1:5
               initialState(15+i,1)= stepsize*i;
            end
            for i=1:4
                initialState(20+i,1)= 50-stepsize*i;
            end
            for i=25:80
                initialState(i,1)=base;
            end
        end
        else if figIndex == 3

            initialState = zeros(dimensionality,1); 
            base = 10;
            for k=1:dimensionality
                for i=1:12
                    initialState(i,1)= base;
                end
                for i=1:3
                   initialState(12+i,1)= stepsize*i;
                end
                for i=1:2
                    initialState(15+i,1)= 30-stepsize*i;
                end
                for i=1:4
                   initialState(17+i,1)= stepsize*i;
                end
                for i=1:3
                    initialState(21+i,1)= 40-stepsize*i;
                end
                for i=25:80
                    initialState(i,1)=base;
                end
            end
            else if figIndex == 4
        
                base = 10;
                for k=1:dimensionality
                    for i=1:12
                        initialState(i,1)= base;
                    end
                    for i=1:3
                       initialState(12+i,1)= stepsize*i;
                    end
                    for i=1:2
                        initialState(15+i,1)= 30-stepsize*i;
                    end
                    for i=1:4
                       initialState(17+i,1)= stepsize*i;
                    end
                    for i=1:3
                        initialState(21+i,1)= 40-stepsize*i;
                    end
                    for i=25:80
                        initialState(i,1)=base;
                    end
                end
            end
        end
        end
    end
    
 
    weightMatrix = zeros(dimensionality,dimensionality);
    stateVec = initialState; 
    
    figure;
    x=initialState;
    y=1:dimensionality;
    plot(x,y,'+'); %plot initial state
    
    set(gca, 'XAxisLocation', 'top')
    set(gca,'ydir','reverse')
    xlabel('Firing rate: Spikes/second')
    ylabel('neuron')
    axis([0 50,12 30])
    title(strcat(name2{figIndex},'| Length Constant= ',num2str(length_constant),'| Maximum Inhibition= ', num2str(maxInhibition)));
    figIndex = figIndex + 1;
    
    for i=1:dimensionality
        for j=1:dimensionality
            dist = distMat(i,j);
            weightMatrix(i,j) = -(maxInhibition*exp(-(dist/length_constant)));        
            if(i==j)
                weightMatrix(i,j) = 0.01;%no self inhibition for winner take all system
            end
        end
    end

    for t=1:time 
        previousState = stateVec;
        
        deltaF = weightMatrix*previousState;
        deltaF = deltaF + initialState - previousState;
        stateVec = stateVec + epsilon*deltaF;
     
        stateVec(stateVec<lowerLimit) = lowerLimit;
        stateVec(stateVec>upperLimit) = upperLimit;
    end

    hold on;
    x=stateVec;
    y=1:dimensionality;
    plot(x,y,'*'); %plot final state
    hold off;
    legend({'Initial State', 'Final State'});

end



