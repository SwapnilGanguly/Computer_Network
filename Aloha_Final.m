% Simulation Parameters
numNodes = 10; % Number of nodes
numSlots = 1000; % Total time slots
transmissionProb = 0.1; % Probability of transmission in a slot

% Initialize variables
successful_aloha = 0;
collisions_aloha = 0;

successful_slotted = 0;
collisions_slotted = 0;

% ALOHA Simulation
for i = 1:numSlots
    transmissions = rand(1, numNodes) < transmissionProb; % Random transmissions
    if sum(transmissions) == 1
        successful_aloha = successful_aloha + 1; % Successful transmission
    elseif sum(transmissions) > 1
        collisions_aloha = collisions_aloha + 1; % Collision
    end
end

% Slotted ALOHA Simulation
for i = 1:numSlots
    transmissions = rand(1, numNodes) < transmissionProb; % Slot-based transmissions
    if sum(transmissions) == 1
        successful_slotted = successful_slotted + 1; % Successful transmission
    elseif sum(transmissions) > 1
        collisions_slotted = collisions_slotted + 1; % Collision
    end
end

% Calculate Metrics
throughput_aloha = (successful_aloha / numSlots) * 100;
collision_rate_aloha = (collisions_aloha / numSlots) * 100;

throughput_slotted = (successful_slotted / numSlots) * 100;
collision_rate_slotted = (collisions_slotted / numSlots) * 100;

% Display Results
disp(['ALOHA - Throughput: ', num2str(throughput_aloha), '%']);
disp(['ALOHA - Collision Rate: ', num2str(collision_rate_aloha), '%']);
disp(['Slotted ALOHA - Throughput: ', num2str(throughput_slotted), '%']);
disp(['Slotted ALOHA - Collision Rate: ', num2str(collision_rate_slotted), '%']);

%% 


G=0:0.25:5;
S=G.*exp(-2*G);
plot(G,S,'r');

title("pure aloha");
xlabel("load offered");
ylabel("throughput");
text(.5,.06,"throughput for Pure Aloha");
%% 
hold on

G=0:0.25:5;
S=G.*exp(-G);
plot(G,S,'b');

title("aloha");
xlabel("load offered");
ylabel("throughput");
text(.5,.2,"throughput for slotted Aloha");

hold off