import React, { 
  useState, 
  useRef, 
  useEffect 
} from "react";
import {
	useNuiEvent,
} from "../../utils";
import { 
  Title 
} from "@mantine/core";

interface ActionDataProps {
	title: string;
	description?: string;
	keybind?: string;
}

const ActionWrapper: React.FC = () => {
	const [visible, setVisible] = useState<boolean>(false);
  const [show, setShow] = useState<boolean>(false);
	const canvasRef = useRef<HTMLCanvasElement>(null);
	// const lineRef = useRef<HTMLCanvasElement>(null);
	// const secondLineRef = useRef<HTMLCanvasElement>(null);
	const [state, setState] = useState<ActionDataProps>({
		title: "",
		description: undefined,
		keybind: "E",
	});

	useEffect(() => {
		const canvas = canvasRef.current;
		// const line = lineRef.current;
		// const secondLine = secondLineRef.current;
		if (!canvas /*|| !line || !secondLine*/) return;
		const context = canvas.getContext("2d");
		// const lineContext = line.getContext("2d");
		// const secondLineContext = secondLine.getContext("2d");
		if (!context /*|| !lineContext || !secondLineContext*/) return;

		// Clear the canvas
		context.clearRect(0, 0, canvas.width, canvas.height);

		// Set up properties for the rectangle
		const rectWidth = 30;
		const rectHeight = 30;
		const rectAngle = Math.PI / 4; // 45 degrees in radians
		const rectCenterX = canvas.width / 2;
		const rectCenterY = canvas.height / 2;

		// Translate and rotate the canvas context
		context.translate(rectCenterX, rectCenterY);
		context.rotate(rectAngle);

		// Draw the rotated rectangle
		//context.fillStyle = "rgba(0, 0, 0, 0.5)";
		//context.fillRect(-rectWidth / 2, -rectHeight / 2, rectWidth, rectHeight);
		context.strokeStyle = "rgba(14, 44, 100, 0.86)";
    context.lineWidth = 2.5;
		context.strokeRect(-rectWidth / 2, -rectHeight / 2, rectWidth, rectHeight);

		// Reset the canvas transformation
		context.setTransform(1, 0, 0, 1, 0, 0);

		// Draw the first line (horizontal)
		// lineContext.clearRect(0, 0, line.width, line.height);
		// lineContext.beginPath();
		// lineContext.moveTo(0, 50);
		// lineContext.lineTo(50, 50);
		// lineContext.strokeStyle = "red";
		// lineContext.lineWidth = 2;
		// lineContext.stroke();

		// // Calculate coordinates for the second line
		// const startX = rectCenterX - rectWidth / 2; // Start from the left edge of the rectangle
		// const startY = rectCenterY + rectHeight / 2; // Start from the bottom edge of the rectangle
		// const endX = 0; // End at the left edge of the canvas
		// const endY = startY - (canvas.width - startX); // Go up diagonally at 45 degrees

		// // Draw the second line (diagonal)
		// secondLineContext.clearRect(0, 0, secondLine.width, secondLine.height);
		// secondLineContext.beginPath();
		// secondLineContext.moveTo(0, 0);
		// secondLineContext.lineTo(50, 50);
		// secondLineContext.strokeStyle = "blue";
		// secondLineContext.lineWidth = 2;
		// secondLineContext.stroke();
	}, [state]);

  useNuiEvent<void>("supv_core:action:hide", async () => {
    await new Promise<void>((resolve) => {
      setTimeout(() => {
        resolve();
      }, 20);
    });
    setShow(false);
    setTimeout(() => {
      setVisible(false);
      if (visible) return; // avoid resetting the state if the component is still visible
      setState({
        title: "",
        description: undefined,
        keybind: "E",
      });
    }, 300);
  });

	useNuiEvent<ActionDataProps>("supv_core:action:send", async (data) => {
		await new Promise<void>((resolve) => {
			setTimeout(() => {
				resolve();
			}, 50);
		});

    setState({
      title: data.title || state.title,
      description: data.description || undefined,
      keybind: data.keybind?.toUpperCase() || "E",
    });

    if (!show) setShow(true);
    if (!visible) setVisible(true);
	});

	return (
		<>
			{visible && (
				<div
					style={{
						position: "absolute",
						top: "50%",
						left: "59%",
						transform: "translate(-50%, -50%)",
            animation: show ? "scaleIn .3s" : "scaleOut .4s",
            //backgroundColor: "rgba(0, 0, 0, 0.5)",
						//display: visible ? "block" : "none",
					}}
				>
					<div
						style={{
							position: "relative",
							width: "400px",
							height: "200px",
						}}
					>
						<canvas
							ref={canvasRef}
							width={100}
							height={200}
							style={{
								animation: "rotate-pause 2s linear infinite",
								zIndex: 5,
							}}
						/>
						{/* <canvas
                ref={lineRef}
                width={100}
                height={100}
                style={{
                  zIndex: 10,
                  position: "absolute",
                  top: "43%",
                  left: "20%",
                }}
              />
              <canvas
                ref={secondLineRef}
                width={20}
                height={10}
                style={{
                  zIndex: 10,
                  position: "absolute",
                  top: "64%",
                  left: "18%",
                }}
              /> */}
						<div
							style={{
								position: "absolute",
								top: "49.2%",
								left: "12.6%",
								display: "flex",
                color: "white",
                textShadow: "0 0 5px black",
								transform: "translate(-50%, -50%)",
							}}
						>
							<Title
								order={4}
								color="gray.3"
								style={{ zIndex: 10, fontFamily: "Ubuntu" }}
							>
								{state.keybind}
							</Title>
						</div>
					</div>
					<div
						style={{
							position: "absolute",
							top: "40%",
							left: "14%",
							width: "100%",
							//transform: "translateX(-50%)",
							color: "white",
							fontSize: "1rem",
							textShadow: "0 0 5px black",
						}}
					>
						<Title
							order={4}
							color="gray.3"
							underline={!state.description}
							style={{
								marginLeft: "1.4rem",
								marginBottom: ".03rem",
								fontFamily: "Ubuntu",
							}}
						>
							{state.title}
						</Title>
            {state.description && (
              <Title
                order={6}
                color="gray.3"
                underline
                style={{ marginLeft: "1rem", fontFamily: "Ubuntu" }}
              >
                {state.description}
              </Title>
            )}
					</div>
				</div>
			)}
			<style>
				{`
          @keyframes rotate-pause {
            0% {
              transform: rotate(0deg);
            }
            50% {
              transform: rotate(180deg);
            }
            100% {
              transform: rotate(180deg);
            }
          }

          @keyframes scaleIn {
            from {
              opacity: 0;
              transform: scale(0.5) translate(-50%, -50%);
              transform-origin: center center;
            }
            to {
              opacity: 1;
              transform: scale(1) translate(-50%, -50%);
              transform-origin: center center;
            }
          }

          @keyframes scaleOut {
            from {
              opacity: 1;
              transform: scale(1) translate(-50%, -50%);
              transform-origin: center center;
            }
            to {
              opacity: 0;
              transform: scale(0.5) translate(-50%, -50%);
              transform-origin: center center;
            }
          }
        `}
			</style>
		</>
	);
};

export default ActionWrapper;
