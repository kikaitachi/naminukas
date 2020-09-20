from dynamixel_sdk import *
import time
ids = range(2, 6) # Dynamixel servo motors ids 2 - 5
delta = 200 # How much to turn in single step (4096 = 360 degrees)
beat = 468750000 # Beat duration in nanoseconds for a song with 128 BPM
positions = [] # Dynamixel servo motor positions
port = PortHandler('/dev/ttyUSB0')
port.openPort()
port.setBaudRate(4000000) # 4M bps
packet = PacketHandler(2.0) # Protocol v2
syncWrite = GroupSyncWrite(port, packet, 116, 4) # Goal position
for id in ids:
    packet.write1ByteTxRx(port, id, 10, 4) # Time-based Profile
    packet.write1ByteTxRx(port, id, 11, 4) # Extended Position Control
    packet.write1ByteTxRx(port, id, 64, 1) # Enable torque
    packet.write4ByteTxRx(port, id, 108, beat // 2000000) # Acceleration
    packet.write4ByteTxRx(port, id, 112, beat // 1000000) # Move duration
    positions.append(packet.read4ByteTxRx(port, id, 132)[0]) # Position
def move(deltas):
    for id in ids:
        index = id - ids[0]
        positions[index] = positions[index] + deltas[index]
        syncWrite.addParam(id, [DXL_LOBYTE(DXL_LOWORD(positions[index])),
            DXL_HIBYTE(DXL_LOWORD(positions[index])),
            DXL_LOBYTE(DXL_HIWORD(positions[index])),
            DXL_HIBYTE(DXL_HIWORD(positions[index]))])
    syncWrite.txPacket()
    syncWrite.clearParam()
def choreography():
    for leftTilt in [-delta, 0, delta]:
        for rightTilt in [-delta, 0, delta]:
            for leftDirection in [-delta * 2, 0, delta * 2]:
                for rightDirection in [-delta * 2, 0, delta * 2]:
                    if leftTilt != 0 or rightTilt != 0:
                        yield [[leftTilt, leftTilt, rightTilt, rightTilt],
                            [leftDirection, 0, 0, rightDirection],
                            [-leftTilt, -leftTilt, -rightTilt, -rightTilt],
                            [0, 0, 0, 0]]
    for leftTilt in [-delta, -delta // 2, 0, delta // 2, delta]:
        for rightTilt in [-delta, -delta // 2, 0, delta // 2, delta]:
            if leftTilt != 0 or rightTilt != 0:
                yield [[leftTilt, leftTilt, rightTilt, rightTilt],
                    [-leftTilt, -leftTilt, -rightTilt, -rightTilt],
                    [leftTilt, leftTilt, rightTilt, rightTilt],
                    [-leftTilt, -leftTilt, -rightTilt, -rightTilt]]
    for leftTilt in [-delta, delta]:
        for rightTilt in [-delta, delta]:
            for leftDirection in [-delta * 2, 0, delta * 2]:
                for rightDirection in [-delta * 2, 0, delta * 2]:
                    if leftDirection != 0 or rightDirection != 0:
                        yield [[leftTilt, leftTilt, rightTilt, rightTilt],
                            [leftDirection, 0, 0, rightDirection],
                            [-leftDirection, 0, 0, -rightDirection],
                            [-leftTilt, -leftTilt, -rightTilt, -rightTilt]]
step = 0
startTime = time.clock_gettime_ns(time.CLOCK_MONOTONIC)
for quartet in choreography():
    for deltas in quartet:
        move(deltas)
        step = step + 1
        now = time.clock_gettime_ns(time.CLOCK_MONOTONIC)
        time.sleep((startTime + step * beat - now) / 1000000000)
for id in ids:
    packet.write1ByteTxRx(port, id, 64, 0) # Disable torque
port.closePort()
