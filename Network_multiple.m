% Parameters for Host 1 (H1) and Host 2 (H2)
B1 = 8e6;             % Bandwidth of Link 1 (bps)
B2 = 10e6;            % Bandwidth of Link 2 (bps)
Tp1 = 5e-3;           % Propagation delay for Link 1 (seconds)
Tp2 = 10e-3;          % Propagation delay for Link 2 (seconds)
packet_size = 1e3 * 8; % Packet size (bits)
queue_size = 100;      % Shared router queue capacity (packets)
simulation_time = 10;  % Simulation duration (seconds)
lambda1 = 30;          % Packet arrival rate for H1 (packets/second)
lambda2 = 20;          % Packet arrival rate for H2 (packets/second)
% Initialize variables
time = 0; % Simulation clock
queue = 0; % Packets in the shared router queue
packets_arrived_H1 = 0; % Packets arriving from H1
packets_arrived_H2 = 0; % Packets arriving from H2
packets_dropped = 0; % Total packets dropped due to queue overflow
packets_sent = 0; % Total packets transmitted
transmission_start_time = 0; % Time when the next packet can be transmitted
% Storage for metrics
arrival_times_H1 = [];
arrival_times_H2 = [];
transmission_times = [];
cumulative_packets_sent = [];
% Poisson arrival for H1 and H2
while time < simulation_time
    % Generate packet arrivals for H1 and H2
    inter_arrival_time_H1 = exprnd(1 / lambda1);
    inter_arrival_time_H2 = exprnd(1 / lambda2);
    next_arrival_H1 = time + inter_arrival_time_H1;
    next_arrival_H2 = time + inter_arrival_time_H2;
    next_arrival = min(next_arrival_H1, next_arrival_H2);
    time = next_arrival;
    if time > simulation_time
        break;
    end
    % Determine packet source (H1 or H2)
    if next_arrival == next_arrival_H1
        packets_arrived_H1 = packets_arrived_H1 + 1;
        arrival_times_H1(end + 1) = time;
    else
        packets_arrived_H2 = packets_arrived_H2 + 1;
        arrival_times_H2(end + 1) = time;
    end
    % Router queue management
    if queue < queue_size
        queue = queue + 1;
    else
        packets_dropped = packets_dropped + 1;
    end
    % Transmit packet from queue
    if queue > 0 && time >= transmission_start_time
        queue = queue - 1; % Remove packet from the queue
        packets_sent = packets_sent + 1;
        % Use appropriate link bandwidth and propagation delay
        if next_arrival == next_arrival_H1
            transmission_time = packet_size / B1 + Tp1;
        else
            transmission_time = packet_size / B2 + Tp2;
        end
        transmission_start_time = time + transmission_time;
        transmission_times(end + 1) = transmission_start_time;
        cumulative_packets_sent(end + 1) = packets_sent;
    end
end
% Calculate Metrics
throughput = (packets_sent * packet_size) / simulation_time; % Throughput in bps
all_arrival_times = [arrival_times_H1, arrival_times_H2]; % Combine arrival times from both hosts
all_arrival_times = sort(all_arrival_times); % Sort arrival times in ascending order
average_delay = mean(transmission_times - all_arrival_times(1:length(transmission_times))); % Average delay in seconds
packet_loss_rate = (packets_dropped / (packets_arrived_H1 + packets_arrived_H2)) * 100; % Packet loss percentage
% Display Results
fprintf('Throughput: %.2f Mbps\n', throughput / 1e6);
fprintf('Average Delay: %.2f ms\n', average_delay * 1e3);
fprintf('Packet Loss Rate: %.2f%%\n', packet_loss_rate);
% Plot Results
figure;
subplot(3, 1, 1);
stairs(arrival_times_H1, 1:length(arrival_times_H1), 'b', 'DisplayName', 'H1');
hold on;
stairs(arrival_times_H2, 1:length(arrival_times_H2), 'r', 'DisplayName', 'H2');
xlabel('Time (s)');
ylabel('Cumulative Packet Arrivals');
title('Packet Arrivals from H1 and H2');
legend;
subplot(3, 1, 2);
stairs(transmission_times, 1:length(transmission_times), 'g');
xlabel('Time (s)');
ylabel('Cumulative Packet Transmissions');
title('Packet Transmissions from Router');
subplot(3, 1, 3);
plot(1:length(cumulative_packets_sent), cumsum(packet_size / 8 * ones(size(cumulative_packets_sent))) / 1e6, 'k');
xlabel('Packet Number');
ylabel('Data Transmitted (MB)');
title('Cumulative Data Transmitted');
