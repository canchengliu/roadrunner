import traci
import time
import traci.constants as tc

def run_simulation():
    step = 0

    # 假设我们控制一个交通信号灯，id 为 "42442621"
    tls_id = "42442621"
    
    # 获取该信号灯的相位总数（这里假设信号灯有多个预定义相位）
    # 注意：获取方式取决于如何设置交通信号灯程序。此处为示例
    # 如果你需要自定义存储相位信息，可以提前定义一个列表，如 phases = [0, 1, 2, 3]
    phases = [0, 1, 2, 3]  
    current_phase = traci.trafficlight.getPhase(tls_id)
    
    while traci.simulation.getMinExpectedNumber() > 0:
        time.sleep(0.5)
        traci.simulationStep()  # 执行一个仿真步
        
        # 这里可以添加检测各个控制道路上车流状态的逻辑，
        # 如使用 traci.lane.getLastStepVehicleNumber(laneID) 或 traci.edge.getLastStepOccupancy(edgeID)
        # 根据实时数据计算是否需要改变信号灯的下一阶段相位
        
        # 示例：每 10 个仿真步骤切换一次相位
        if step % 10 == 0:
            # 计算下一个相位（可以用更复杂的算法）
            next_phase = (current_phase + 1) % len(phases)
            traci.trafficlight.setPhase(tls_id, next_phase)
            print("Step {}: Traffic light {} switched to phase {}".format(step, tls_id, next_phase))
            current_phase = next_phase
        
        step += 1

    traci.close()

def main():
    # 启动 SUMO 仿真（使用图形界面或无头模式）
    sumoBinary = "sumo-gui"  # 如需无头模式，可将其替换为 "sumo"
    sumoCmd = [sumoBinary, "-c", "map.sumocfg"]
    
    traci.start(sumoCmd)
    run_simulation()

if __name__ == "__main__":
    main() 