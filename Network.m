% Network Parameters
B = 10e6;              % Bandwidth (bps)
packet_size = 1e3 * 8; % Packet size (bits)
Tp = 10e-3;            % Propagation delay (seconds)
queue_size = 50;       % Router queue capacity (packets)
simulation_time = 10;  % Total simulation time (seconds)
lambda = 20;           % Packet arrival rate (packets/second, Poisson)
% Initialize Variables
time = 0;                 % Simulation clock
queue = 0;                % Packets in the router queue
packets_arrived = 0;      % Total packets arrived
packets_dropped = 0;      % Total packets dropped
packets_sent = 0;         % Total packets sent
arrival_times = [];       % Packet arrival times
transmission_times = [];  % Packet transmission times
% Router and Host Simulation
transmission_start_time = 0; % Next possible transmission start time
packet_transmission_time = packet_size / B; % Time to transmit one packet
% Simulate Packet Arrival and Transmission
while time < simulation_time
    % Generate next packet arrival time using Poisson process
    inter_arrival_time = exprnd(1 / lambda);
    time = time + inter_arrival_time;
    if time > simulation_time
        break;
    end 
    % Packet arrives at the router
    packets_arrived = packets_arrived + 1;
    arrival_times(end + 1) = time;
    % Check if the queue is full
    if queue < queue_size
        queue = queue + 1;
    else
        packets_dropped = packets_dropped + 1;
    end
    % Process transmission
    if queue > 0 && time >= transmission_start_time
        queue = queue - 1; % Remove packet from the queue
        packets_sent = packets_sent + 1;
        transmission_start_time = time + packet_transmission_time + Tp; % Update next transmission time
        transmission_times(end + 1) = transmission_start_time;
    end
end
% Calculate Metrics
throughput = (packets_sent * packet_size) / simulation_time; % Throughput in bps
average_delay = mean(transmission_times - arrival_times(1:length(transmission_times))); % Average delay in seconds
packet_loss_rate = (packets_dropped / packets_arrived) * 100; % Packet loss percentage
% Display Results
fprintf('Throughput: %.2f Mbps\n', throughput / 1e6);
fprintf('Average Delay: %.2f ms\n', average_delay * 1e3);
fprintf('Packet Loss Rate: %.2f%%\n', packet_loss_rate);
% Plot Results
figure;
subplot(3, 1, 1);
stairs(arrival_times, 1:length(arrival_times), 'b');
xlabel('Time (s)');
ylabel('Cumulative Packets Arrived');
title('Packet Arrivals at Router');
subplot(3, 1, 2);
stairs(transmission_times, 1:length(transmission_times), 'r');
xlabel('Time (s)');
ylabel('Cumulative Packets Transmitted');
title('Packet Transmissions from Router');
subplot(3, 1, 3);
plot(1:length(transmission_times), cumsum(packet_size/8 * ones(size(transmission_times))) / 1e6, 'g');
xlabel('Packet Number');
ylabel('Data Transmitted (MB)');
title('Cumulative Data Transmitted');
