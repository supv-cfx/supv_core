import React, { useState, useRef, useEffect } from "react";
import { useNuiEvent } from "../../hooks/useNuiEvent";
import { CrosshairProps, CrosshairDefault } from "../../typings";

const Crosshair: React.FC = () => {
	const [visible, setVisible] = useState(false);
	const canvasRef = useRef<HTMLCanvasElement>(null);
	const [crosshair, setCrosshair] = useState<CrosshairProps>(CrosshairDefault);

	useNuiEvent("supv_core:crosshair:visible", async (data: boolean) => {
		await new Promise((resolve) => setTimeout(resolve, 200));
		setVisible(data);
		//console.log(`Crosshair visibility: ${data}`);
	});

	useNuiEvent("supv_core:crosshair:setter", async (data) => {
		await new Promise((resolve) => setTimeout(resolve, 200));
		setCrosshair(data);
	});

	useEffect(() => {
		// Dessiner le crosshair sur le canvas lors de la première rendu et à chaque mise à jour de crosshair
		const canvas = canvasRef.current;
		if (!canvas) return;

		const ctx = canvas.getContext("2d");
		const ctxDot = canvas.getContext("2d");
		if (!ctx) return;
		if (!ctxDot) return;

		// Effacer le canvas
		ctx.clearRect(0, 0, canvas.width, canvas.height);

		// Avoir le centre du canvas
		const centerX = canvas.width / 2;
		const centerY = canvas.height / 2;

		if (crosshair.show_cross) {
			// Changer l'épaisseur du crosshair
			ctx.lineWidth = crosshair.thickness;
			ctx.globalAlpha = crosshair.alpha / 255;

			//couleur Epaisseur du contour du crosshair
			ctx.shadowColor = "rgba(0, 0, 0, 1)";
			ctx.lineCap = crosshair.cap;

			// Changer la couleur du crosshair
			switch (crosshair.color) {
				case 0: // noir
					ctx.strokeStyle = `rgba(0, 0, 0, ${
						crosshair.useAlpha ? 200 / 255 : crosshair.alpha / 255
					})`;
					break;
				case 1:
					ctx.strokeStyle = `rgba(255, 255, 255, ${
						crosshair.useAlpha ? 200 / 255 : crosshair.alpha / 255
					})`;
					break;
				case 2:
					ctx.strokeStyle = `rgba(255, 0, 0, ${
						crosshair.useAlpha ? 200 / 255 : crosshair.alpha / 255
					})`;
					break;
				case 3:
					ctx.strokeStyle = `rgba(0, 255, 0, ${
						crosshair.useAlpha ? 200 / 255 : crosshair.alpha / 255
					})`;
					break;
				case 4:
					ctx.strokeStyle = `rgba(0, 0, 255, ${
						crosshair.useAlpha ? 200 / 255 : crosshair.alpha / 255
					})`;
					break;
				case 5:
					ctx.strokeStyle = `rgba(${crosshair.color_r}, ${crosshair.color_g}, ${
						crosshair.color_b
					}, ${crosshair.useAlpha ? 200 / 255 : crosshair.alpha / 255})`;
					break;
				default:
					ctx.strokeStyle = `rgba(${crosshair.color_r}, ${crosshair.color_g}, ${
						crosshair.color_b
					}, ${crosshair.useAlpha ? 200 / 255 : crosshair.alpha / 255})`;
			}
			// Dessiner le crosshair (ligne horizontale gauche)
			ctx.beginPath();
			ctx.moveTo(centerX - crosshair.size / 1.2, centerY);
			ctx.lineTo(centerX - crosshair.gap, centerY);
			ctx.stroke();

			// Dessiner le crosshair (ligne horizontale droite)
			ctx.beginPath();
			ctx.moveTo(centerX + crosshair.size / 1.2, centerY);
			ctx.lineTo(centerX + crosshair.gap, centerY);
			ctx.stroke();

			// Dessiner le crosshair (ligne verticale haut)
			ctx.beginPath();
			ctx.moveTo(centerX, centerY - crosshair.size / 1.2);
			ctx.lineTo(centerX, centerY - crosshair.gap);
			ctx.stroke();

			// Dessiner le crosshair (ligne verticale bas)
			ctx.beginPath();
			ctx.moveTo(centerX, centerY + crosshair.size / 1.2);
			ctx.lineTo(centerX, centerY + crosshair.gap);
			ctx.stroke();
		}

		if (crosshair.dot) {
			// Changer l'épaisseur du point
			ctxDot.lineWidth = crosshair.dot_thickness;
			ctxDot.globalAlpha = crosshair.dot_alpha / 255;

			//couleur Epaisseur du contour du point
			ctxDot.shadowColor = "rgba(0, 0, 0, 1)";
			ctxDot.lineCap = crosshair.cap;

			// Dessiner le contour du point
			if (crosshair.dot_drawOutline) {
				// Changer la couleur du point
				switch (crosshair.dot_outColor) {
					case 0: // noir
						ctxDot.strokeStyle = `rgba(0, 0, 0, ${
							crosshair.dot_outAlpha ? 200 / 255 : crosshair.dot_outAlpha / 255
						})`;
						break;
					case 1:
						ctxDot.strokeStyle = `rgba(255, 255, 255, ${
							crosshair.dot_outAlpha ? 200 / 255 : crosshair.dot_outAlpha / 255
						})`;
						break;
					case 2:
						ctxDot.strokeStyle = `rgba(255, 0, 0, ${
							crosshair.dot_outAlpha ? 200 / 255 : crosshair.dot_outAlpha / 255
						})`;
						break;
					case 3:
						ctxDot.strokeStyle = `rgba(0, 255, 0, ${
							crosshair.dot_outAlpha ? 200 / 255 : crosshair.dot_outAlpha / 255
						})`;
						break;
					case 4:
						ctxDot.strokeStyle = `rgba(0, 0, 255, ${
							crosshair.dot_outAlpha ? 200 / 255 : crosshair.dot_outAlpha / 255
						})`;
						break;
					case 5:
						ctxDot.strokeStyle = `rgba(${crosshair.dot_outColor_r}, ${
							crosshair.dot_outColor_g
						}, ${crosshair.dot_outColor_b}, ${
							crosshair.dot_outAlpha ? 200 / 255 : crosshair.dot_outAlpha / 255
						})`;
						break;
					default:
						ctxDot.strokeStyle = `rgba(${crosshair.dot_outColor_r}, ${
							crosshair.dot_outColor_g
						}, ${crosshair.dot_outColor_b}, ${
							crosshair.dot_outAlpha ? 200 / 255 : crosshair.dot_outAlpha / 255
						})`;
				}
				ctxDot.beginPath();
				ctxDot.arc(
					canvas.width / 2,
					canvas.height / 2,
					crosshair.dot_size,
					0,
					2 * Math.PI
				);
				ctxDot.lineWidth = crosshair.dot_outlineThickness / crosshair.dot_size;
				ctxDot.stroke();
			}

			// Changer la couleur du point
			switch (crosshair.dot_color) {
				case 0: // noir
					ctxDot.fillStyle = `rgba(0, 0, 0, ${
						crosshair.dot_useAlpha ? 200 / 255 : crosshair.dot_alpha / 255
					})`;
					break;
				case 1:
					ctxDot.fillStyle = `rgba(255, 255, 255, ${
						crosshair.dot_useAlpha ? 200 / 255 : crosshair.dot_alpha / 255
					})`;
					break;
				case 2:
					ctxDot.fillStyle = `rgba(255, 0, 0, ${
						crosshair.dot_useAlpha ? 200 / 255 : crosshair.dot_alpha / 255
					})`;
					break;
				case 3:
					ctxDot.fillStyle = `rgba(0, 255, 0, ${
						crosshair.dot_useAlpha ? 200 / 255 : crosshair.dot_alpha / 255
					})`;
					break;
				case 4:
					ctxDot.fillStyle = `rgba(0, 0, 255, ${
						crosshair.dot_useAlpha ? 200 / 255 : crosshair.dot_alpha / 255
					})`;
					break;
				case 5:
					ctxDot.fillStyle = `rgba(${crosshair.dot_color_r}, ${
						crosshair.dot_color_g
					}, ${crosshair.dot_color_b}, ${
						crosshair.dot_useAlpha ? 200 / 255 : crosshair.dot_alpha / 255
					})`;
					break;
				default:
					ctxDot.fillStyle = `rgba(${crosshair.dot_color_r}, ${
						crosshair.dot_color_g
					}, ${crosshair.dot_color_b}, ${
						crosshair.dot_useAlpha ? 200 / 255 : crosshair.dot_alpha / 255
					})`;
			}
			ctxDot.beginPath();
			ctxDot.arc(
				canvas.width / 2,
				canvas.height / 2,
				crosshair.dot_size,
				0,
				2 * Math.PI
			);
			ctxDot.fill();
			// Changer couleur du point
		}
	}, [crosshair]);

	return (
		<canvas
			ref={canvasRef}
			width={150}
			height={150}
			style={{
				zIndex: 1,
				position: "absolute",
				top: "50%",
				left: "50%",
				transform: "translate(-50%, -50%)",
				visibility: visible ? "visible" : "hidden",
			}}
		/>
	);
};

export default Crosshair;
