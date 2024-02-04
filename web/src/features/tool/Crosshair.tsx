import React, { useState, useEffect, useRef, useCallback } from "react";
import {
	Box,
	Slider,
	Group,
	Container,
	Checkbox,
	Select,
	ActionIcon,
	Divider,
	Text,
	Modal,
	Input,
} from "@mantine/core";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
	faXmarkSquare,
	faFloppyDisk,
	faDotCircle,
	faCrosshairs,
	faEye,
	faXmark,
	faCheck,
} from "@fortawesome/free-solid-svg-icons";
import { CrosshairProps, CrosshairDefault } from "../../typings";
import { useNuiEvent } from "../../hooks/useNuiEvent";
import { fetchNui } from "../../utils/fetchNui";
import AnimatedButton from "../modal/components/buttons";
import { useDisclosure } from "@mantine/hooks";

const CrosshairTool: React.FC = () => {
	const [opened, { close, open }] = useDisclosure(false);
	const [name, setName] = useState("");
	const [visible, setVisible] = useState(false);
	const [crosshairParams, setCrosshairParams] =
		useState<CrosshairProps>(CrosshairDefault);
	const cRef = useRef<HTMLCanvasElement>(null);

	useNuiEvent("supv_core:crosshairtool:visible", async (data: boolean) => {
		setVisible(data);
    await new Promise((resolve) => setTimeout(resolve, 200));
		if (data) DrawCrosshairTool();
  });

	const SaveCrosshair = async () => {
		fetchNui("supv_core:crosshair:save", {
			name: name,
			crosshair: crosshairParams,
		});
		close();
	};

	const handleClose = () => {
		setVisible(false);
		fetchNui("supv_core:crosshairtool:close");
		if (opened) close();
	};

  const DrawCrosshairTool = useCallback(() => {
		// Dessiner le crosshair sur le canvas lors de la première rendu et à chaque mise à jour de crosshairParams
		const canvas = cRef.current;
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

		if (crosshairParams.show_cross) {
			// Changer l'épaisseur du crosshair
			ctx.lineWidth = crosshairParams.thickness;
			ctx.globalAlpha = crosshairParams.alpha / 255;

			//couleur Epaisseur du contour du crosshair
			ctx.shadowColor = "rgba(0, 0, 0, 1)";
			ctx.lineCap = crosshairParams.cap;

			// Changer la couleur du crosshair
			switch (crosshairParams.color) {
				case 0: // noir
					ctx.strokeStyle = `rgba(0, 0, 0, ${
						crosshairParams.useAlpha ? 200 / 255 : crosshairParams.alpha / 255
					})`;
					break;
				case 1:
					ctx.strokeStyle = `rgba(255, 255, 255, ${
						crosshairParams.useAlpha ? 200 / 255 : crosshairParams.alpha / 255
					})`;
					break;
				case 2:
					ctx.strokeStyle = `rgba(255, 0, 0, ${
						crosshairParams.useAlpha ? 200 / 255 : crosshairParams.alpha / 255
					})`;
					break;
				case 3:
					ctx.strokeStyle = `rgba(0, 255, 0, ${
						crosshairParams.useAlpha ? 200 / 255 : crosshairParams.alpha / 255
					})`;
					break;
				case 4:
					ctx.strokeStyle = `rgba(0, 0, 255, ${
						crosshairParams.useAlpha ? 200 / 255 : crosshairParams.alpha / 255
					})`;
					break;
				case 5:
					ctx.strokeStyle = `rgba(${crosshairParams.color_r}, ${
						crosshairParams.color_g
					}, ${crosshairParams.color_b}, ${
						crosshairParams.useAlpha ? 200 / 255 : crosshairParams.alpha / 255
					})`;
					break;
				default:
					ctx.strokeStyle = `rgba(${crosshairParams.color_r}, ${
						crosshairParams.color_g
					}, ${crosshairParams.color_b}, ${
						crosshairParams.useAlpha ? 200 / 255 : crosshairParams.alpha / 255
					})`;
			}
			// Dessiner le crosshair (ligne horizontale gauche)
			ctx.beginPath();
			ctx.moveTo(centerX - crosshairParams.size / 1.2, centerY);
			ctx.lineTo(centerX - crosshairParams.gap, centerY);
			ctx.stroke();

			// Dessiner le crosshair (ligne horizontale droite)
			ctx.beginPath();
			ctx.moveTo(centerX + crosshairParams.size / 1.2, centerY);
			ctx.lineTo(centerX + crosshairParams.gap, centerY);
			ctx.stroke();

			// Dessiner le crosshair (ligne verticale haut)
			ctx.beginPath();
			ctx.moveTo(centerX, centerY - crosshairParams.size / 1.2);
			ctx.lineTo(centerX, centerY - crosshairParams.gap);
			ctx.stroke();

			// Dessiner le crosshair (ligne verticale bas)
			ctx.beginPath();
			ctx.moveTo(centerX, centerY + crosshairParams.size / 1.2);
			ctx.lineTo(centerX, centerY + crosshairParams.gap);
			ctx.stroke();
		}

		if (crosshairParams.dot) {
			// Changer l'épaisseur du point
			ctxDot.lineWidth = crosshairParams.dot_thickness;
			ctxDot.globalAlpha = crosshairParams.dot_alpha / 255;

			//couleur Epaisseur du contour du point
			ctxDot.shadowColor = "rgba(0, 0, 0, 1)";
			ctxDot.lineCap = crosshairParams.cap;

			// Dessiner le contour du point
			if (crosshairParams.dot_drawOutline) {
				// Changer la couleur du point
				switch (crosshairParams.dot_outColor) {
					case 0: // noir
						ctxDot.strokeStyle = `rgba(0, 0, 0, ${
							crosshairParams.dot_outAlpha
								? 200 / 255
								: crosshairParams.dot_outAlpha / 255
						})`;
						break;
					case 1:
						ctxDot.strokeStyle = `rgba(255, 255, 255, ${
							crosshairParams.dot_outAlpha
								? 200 / 255
								: crosshairParams.dot_outAlpha / 255
						})`;
						break;
					case 2:
						ctxDot.strokeStyle = `rgba(255, 0, 0, ${
							crosshairParams.dot_outAlpha
								? 200 / 255
								: crosshairParams.dot_outAlpha / 255
						})`;
						break;
					case 3:
						ctxDot.strokeStyle = `rgba(0, 255, 0, ${
							crosshairParams.dot_outAlpha
								? 200 / 255
								: crosshairParams.dot_outAlpha / 255
						})`;
						break;
					case 4:
						ctxDot.strokeStyle = `rgba(0, 0, 255, ${
							crosshairParams.dot_outAlpha
								? 200 / 255
								: crosshairParams.dot_outAlpha / 255
						})`;
						break;
					case 5:
						ctxDot.strokeStyle = `rgba(${crosshairParams.dot_outColor_r}, ${
							crosshairParams.dot_outColor_g
						}, ${crosshairParams.dot_outColor_b}, ${
							crosshairParams.dot_outAlpha
								? 200 / 255
								: crosshairParams.dot_outAlpha / 255
						})`;
						break;
					default:
						ctxDot.strokeStyle = `rgba(${crosshairParams.dot_outColor_r}, ${
							crosshairParams.dot_outColor_g
						}, ${crosshairParams.dot_outColor_b}, ${
							crosshairParams.dot_outAlpha
								? 200 / 255
								: crosshairParams.dot_outAlpha / 255
						})`;
				}
				ctxDot.beginPath();
				ctxDot.arc(
					canvas.width / 2,
					canvas.height / 2,
					crosshairParams.dot_size,
					0,
					2 * Math.PI
				);
				ctxDot.lineWidth =
					crosshairParams.dot_outlineThickness / crosshairParams.dot_size;
				ctxDot.stroke();
			}

			// Changer la couleur du point
			switch (crosshairParams.dot_color) {
				case 0: // noir
					ctxDot.fillStyle = `rgba(0, 0, 0, ${
						crosshairParams.dot_useAlpha
							? 200 / 255
							: crosshairParams.dot_alpha / 255
					})`;
					break;
				case 1:
					ctxDot.fillStyle = `rgba(255, 255, 255, ${
						crosshairParams.dot_useAlpha
							? 200 / 255
							: crosshairParams.dot_alpha / 255
					})`;
					break;
				case 2:
					ctxDot.fillStyle = `rgba(255, 0, 0, ${
						crosshairParams.dot_useAlpha
							? 200 / 255
							: crosshairParams.dot_alpha / 255
					})`;
					break;
				case 3:
					ctxDot.fillStyle = `rgba(0, 255, 0, ${
						crosshairParams.dot_useAlpha
							? 200 / 255
							: crosshairParams.dot_alpha / 255
					})`;
					break;
				case 4:
					ctxDot.fillStyle = `rgba(0, 0, 255, ${
						crosshairParams.dot_useAlpha
							? 200 / 255
							: crosshairParams.dot_alpha / 255
					})`;
					break;
				case 5:
					ctxDot.fillStyle = `rgba(${crosshairParams.dot_color_r}, ${
						crosshairParams.dot_color_g
					}, ${crosshairParams.dot_color_b}, ${
						crosshairParams.dot_useAlpha
							? 200 / 255
							: crosshairParams.dot_alpha / 255
					})`;
					break;
				default:
					ctxDot.fillStyle = `rgba(${crosshairParams.dot_color_r}, ${
						crosshairParams.dot_color_g
					}, ${crosshairParams.dot_color_b}, ${
						crosshairParams.dot_useAlpha
							? 200 / 255
							: crosshairParams.dot_alpha / 255
					})`;
			}
			ctxDot.beginPath();
			ctxDot.arc(
				canvas.width / 2,
				canvas.height / 2,
				crosshairParams.dot_size,
				0,
				2 * Math.PI
			);
			ctxDot.fill();
			// Changer couleur du point
		}
  }, [crosshairParams]);

	useEffect(() => {
    DrawCrosshairTool();
	}, [DrawCrosshairTool]);
	// le container doit prendre la taille de l'ecran
	return (
		<>
			{visible && (
				<Container
					size="sm"
					style={{
						justifyContent: "center",
						alignItems: "center",
						height: "100vh",
						//backgroundColor: "yellow",
					}}
				>
					<Modal
						opened={opened}
						onClose={close}
						title="Save crosshair"
						size="sm"
						closeOnEscape
						centered
						transitionProps={{
							duration: 150,
							timingFunction: "ease-in-out",
							transition: "skew-down",
						}}
					>
						<Input
							placeholder="Name"
							onChange={(event) => {
								setName(event.currentTarget.value);
							}}
						/>
						<Group align="right" position="right" pt={20}>
							<AnimatedButton
								iconAwesome={faXmark}
								text="Annuler"
								onClick={close}
								color="red.6"
								args={false}
							/>
							<AnimatedButton
								iconAwesome={faCheck}
								text="Valider"
								onClick={SaveCrosshair}
								color="teal.6"
								args={true}
							/>
						</Group>
					</Modal>
					<Box
						style={{
							//display: "flex",
							marginTop: "10vh",
							marginBottom: "10vh",
							height: "100%",
							//backgroundColor: "rgba(0, 0, 0, 0.5)",
						}}
					>
						<Box bg={"dark"}>
							<Box
								style={{
									width: "100%",
									height: 20,
									display: "flex",
									justifyContent: "space-between",
									alignItems: "center",
								}}
								pl={10}
								bg={"dark.6"}
							>
								<ActionIcon
									variant="light"
									color="gray"
									radius="xs"
									size={"sm"}
									onClick={open}
								>
									<FontAwesomeIcon icon={faFloppyDisk} />
								</ActionIcon>
								<Text align="center" size={"xs"}>
									Crosshair Tool
								</Text>
								<ActionIcon
									variant="light"
									color={"red"}
									size={20}
									onClick={handleClose}
								>
									<FontAwesomeIcon icon={faXmarkSquare} />
								</ActionIcon>
							</Box>
							<Divider
								color="white"
								m={1}
								label={
									<>
										<FontAwesomeIcon icon={faCrosshairs} shake />
										<Box ml={5}>Crosshair</Box>
									</>
								}
								labelPosition="center"
								size={"lg"}
							/>
							<Box
								style={{
									display: "flex",
									flexDirection: "column",
									width: "100%",
									//backgroundColor: "rgba(255, 255, 255, 0.5)",
								}}
								bg={"dark"}
							>
								{/**Group juste pour la croix */}
								<Group pt={2} position="center">
									{/* show */}
									<Divider color="white" orientation="vertical" />
									<Checkbox
										label="Show"
										labelPosition="left"
										size={"xs"}
										checked={crosshairParams.show_cross === true ? true : false}
										onChange={(event) =>
											setCrosshairParams({
												...crosshairParams,
												show_cross: event.currentTarget.checked ? true : false,
											})
										}
									/>
									<Divider color="white" orientation="vertical" />
									{/* use alpha */}
									{crosshairParams.show_cross && (
										<>
											<Checkbox
												label="Default alpha"
												labelPosition="left"
												size={"xs"}
												checked={crosshairParams.useAlpha === 1 ? true : false}
												onChange={(event) =>
													setCrosshairParams({
														...crosshairParams,
														useAlpha: event.currentTarget.checked ? 1 : 0,
													})
												}
											/>
											<Divider color="white" orientation="vertical" />
										</>
									)}
									{/* draw outline }
                      <Checkbox
                      label="Draw Outline"
                      labelPosition="left"
                      size={"xs"}
                      checked={crosshairParams.drawOutline === 1 ? true : false}
                      onChange={(event) =>
                          setCrosshairParams({
                              ...crosshairParams,
                              drawOutline: event.currentTarget.checked ? 1 : 0,
                          })
                      }
                      />
                      <Divider color="white" orientation="vertical" />
                      {/* fixed gap */}
								</Group>
							</Box>
							{crosshairParams.show_cross && (
								<Box style={{ display: "flex", flexDirection: "row" }}>
									<Box
										bg={"dark"}
										style={{
											flexDirection: "column",
											width: "50%",
										}}
									>
										<Box>
											<Group w={"100%"} pl={5} position="center" pb={5}>
												<Select
													data={[
														{ value: "0", label: "Black" },
														{ value: "1", label: "White" },
														{ value: "2", label: "Red" },
														{ value: "3", label: "Green" },
														{ value: "4", label: "Blue" },
														{ value: "5", label: "Custom" },
													]}
													transitionProps={{
														duration: 100,
														timingFunction: "ease-in-out",
														transition: "skew-down",
													}}
													label="Color"
													value={crosshairParams.color.toString()}
													onChange={(value) => {
														if (value !== null) {
															const numericValue = parseInt(value);
															if (!isNaN(numericValue)) {
																console.log(numericValue);
																setCrosshairParams({
																	...crosshairParams,
																	color: numericValue,
																});
															}
														}
													}}
												/>
											</Group>
											{crosshairParams.color === 5 && (
												<>
													<Group w={"100%"} position="center">
														<Slider
															labelTransition={"skew-up"}
															labelTransitionDuration={100}
															labelTransitionTimingFunction="ease-in-out"
															value={crosshairParams.color_r}
															onChange={(value) =>
																setCrosshairParams({
																	...crosshairParams,
																	color_r: value,
																})
															}
															min={0}
															max={255}
															step={1}
															w={150}
															p={5}
														/>
														<Text size={"xs"}>Color R</Text>
													</Group>
													<Group w={"100%"} position="center">
														<Slider
															labelTransition={"skew-up"}
															labelTransitionDuration={100}
															labelTransitionTimingFunction="ease-in-out"
															value={crosshairParams.color_g}
															onChange={(value) =>
																setCrosshairParams({
																	...crosshairParams,
																	color_g: value,
																})
															}
															min={0}
															max={255}
															step={1}
															w={150}
															p={5}
														/>
														<Text size={"xs"}>Color G</Text>
													</Group>
													<Group w={"100%"} position="center">
														<Slider
															labelTransition={"skew-up"}
															labelTransitionDuration={100}
															labelTransitionTimingFunction="ease-in-out"
															value={crosshairParams.color_b}
															onChange={(value) =>
																setCrosshairParams({
																	...crosshairParams,
																	color_b: value,
																})
															}
															min={0}
															max={255}
															step={1}
															w={150}
															p={5}
														/>
														<Text size={"xs"}>Color B</Text>
													</Group>
												</>
											)}
											{crosshairParams.useAlpha === 0 && (
												<Group w={"100%"} position="center">
													<Slider
														labelTransition={"skew-up"}
														labelTransitionDuration={100}
														labelTransitionTimingFunction="ease-in-out"
														value={crosshairParams.alpha}
														onChange={(value) =>
															setCrosshairParams({
																...crosshairParams,
																alpha: value,
															})
														}
														min={0}
														max={255}
														step={1}
														w={150}
														p={5}
													/>
													<Text pl={5} size={"xs"}>
														Alpha
													</Text>
												</Group>
											)}
										</Box>
									</Box>
									<Box
										bg={"dark"}
										style={{
											display: "flex",
											flexDirection: "column",
											alignItems: "center",
											width: "50%",
										}}
									>
										{/** cap */}
										<Group position="center">
											<Select
												data={[
													{ value: "round", label: "Round" },
													{ value: "butt", label: "Butt" },
													{ value: "square", label: "Square" },
												]}
												label="Cap"
												transitionProps={{
													duration: 100,
													timingFunction: "ease-in-out",
													transition: "skew-down",
												}}
												value={crosshairParams.cap}
												onChange={(value) => {
													if (
														value === "round" ||
														value === "butt" ||
														value === "square"
													) {
														setCrosshairParams({
															...crosshairParams,
															cap: value,
														});
													}
												}}
											/>
										</Group>
										{/* size */}
										<Group w={"100%"} position="right">
											<Text size={"xs"}>Size</Text>
											<Slider
												value={crosshairParams.size}
												labelTransition={"skew-up"}
												labelTransitionDuration={100}
												labelTransitionTimingFunction="ease-in-out"
												onChange={(value) =>
													setCrosshairParams({
														...crosshairParams,
														size: value,
													})
												}
												min={0}
												max={100}
												step={1}
												w={200}
												p={5}
											/>
										</Group>
										{/* gap */}
										<Group w={"100%"} position="right">
											<Text size={"xs"}>Gap</Text>
											<Slider
												value={crosshairParams.gap}
												labelTransition={"skew-up"}
												labelTransitionDuration={100}
												labelTransitionTimingFunction="ease-in-out"
												onChange={(value) =>
													setCrosshairParams({
														...crosshairParams,
														gap: value,
													})
												}
												min={0}
												max={100}
												step={1}
												w={200}
												p={5}
											/>
										</Group>
										{/* thickness */}
										<Group w={"100%"} position="right">
											<Text size={"xs"}>Thickness</Text>
											<Slider
												value={crosshairParams.thickness}
												labelTransition={"skew-up"}
												labelTransitionDuration={100}
												labelTransitionTimingFunction="ease-in-out"
												onChange={(value) =>
													setCrosshairParams({
														...crosshairParams,
														thickness: value,
													})
												}
												min={0}
												max={100}
												step={0.1}
												w={200}
												p={5}
											/>
										</Group>
										{/* outline thickness */}
										<Group w={"100%"} position="right">
											<Text size={"xs"}>Outline Thickness</Text>
											<Slider
												value={crosshairParams.outlineThickness}
												labelTransition={"skew-up"}
												labelTransitionDuration={100}
												labelTransitionTimingFunction="ease-in-out"
												onChange={(value) =>
													setCrosshairParams({
														...crosshairParams,
														outlineThickness: value,
													})
												}
												disabled={
													crosshairParams.drawOutline === 0 ? true : false
												}
												min={0}
												max={100}
												step={0.1}
												w={200}
												p={5}
											/>
										</Group>
									</Box>
								</Box>
							)}
							<Divider
								color="white"
								m={1}
								label={
									<>
										<FontAwesomeIcon icon={faDotCircle} shake />
										<Box ml={5}>Dot</Box>
									</>
								}
								labelPosition="center"
								size={"lg"}
							/>
							<Box
								style={{
									display: "flex",
									flexDirection: "column",
									width: "100%",
									//backgroundColor: "rgba(255, 255, 255, 0.5)",
								}}
								bg={"dark"}
							>
								<Group pt={2} position="center">
									<Divider color="white" orientation="vertical" />
									<Checkbox
										label="Show"
										labelPosition="left"
										size={"xs"}
										checked={crosshairParams.dot === 1 ? true : false}
										onChange={(event) =>
											setCrosshairParams({
												...crosshairParams,
												dot: event.currentTarget.checked ? 1 : 0,
											})
										}
									/>
									<Divider color="white" orientation="vertical" />
									{crosshairParams.dot && (
										<>
											<Checkbox
												label="Default alpha"
												labelPosition="left"
												size={"xs"}
												checked={
													crosshairParams.dot_useAlpha === 1 ? true : false
												}
												onChange={(event) =>
													setCrosshairParams({
														...crosshairParams,
														dot_useAlpha: event.currentTarget.checked ? 1 : 0,
														dot_alpha: event.currentTarget.checked
															? 200
															: crosshairParams.dot_alpha,
													})
												}
											/>
											<Divider color="white" orientation="vertical" />
											<Checkbox
												label="Draw Outline"
												labelPosition="left"
												size={"xs"}
												checked={
													crosshairParams.dot_drawOutline === 1 ? true : false
												}
												onChange={(event) =>
													setCrosshairParams({
														...crosshairParams,
														dot_drawOutline: event.currentTarget.checked
															? 1
															: 0,
													})
												}
											/>
											<Divider color="white" orientation="vertical" />
										</>
									)}
								</Group>
								{(crosshairParams.dot && (
									<Box
										bg={"dark"}
										style={{ display: "flex", flexDirection: "row" }}
									>
										<Box
											style={{
												flexDirection: "column",
												width: crosshairParams.dot_drawOutline ? "50%" : "100%",
											}}
										>
											<Group w={"100%"} pl={5} position="center" pb={5}>
												<Select
													data={[
														{ value: "0", label: "Black" },
														{ value: "1", label: "White" },
														{ value: "2", label: "Red" },
														{ value: "3", label: "Green" },
														{ value: "4", label: "Blue" },
														{ value: "5", label: "Custom" },
													]}
													transitionProps={{
														duration: 100,
														timingFunction: "ease-in-out",
														transition: "skew-down",
													}}
													label="Color"
													value={crosshairParams.dot_color.toString()}
													onChange={(value) => {
														if (value !== null) {
															const numericValue = parseInt(value);
															if (!isNaN(numericValue)) {
																console.log(numericValue);
																setCrosshairParams({
																	...crosshairParams,
																	dot_color: numericValue,
																});
															}
														}
													}}
												/>
											</Group>
											{crosshairParams.dot_color === 5 && (
												<>
													<Group w={"100%"} position="center">
														<Slider
															labelTransition={"skew-up"}
															labelTransitionDuration={100}
															labelTransitionTimingFunction="ease-in-out"
															value={crosshairParams.dot_color_r}
															onChange={(value) =>
																setCrosshairParams({
																	...crosshairParams,
																	dot_color_r: value,
																})
															}
															min={0}
															max={255}
															step={1}
															w={150}
															p={5}
														/>
														<Text size={"xs"}>Color R</Text>
													</Group>
													<Group w={"100%"} position="center">
														<Slider
															labelTransition={"skew-up"}
															labelTransitionDuration={100}
															labelTransitionTimingFunction="ease-in-out"
															value={crosshairParams.dot_color_g}
															onChange={(value) =>
																setCrosshairParams({
																	...crosshairParams,
																	dot_color_g: value,
																})
															}
															min={0}
															max={255}
															step={1}
															w={150}
															p={5}
														/>
														<Text size={"xs"}>Color G</Text>
													</Group>

													<Group w={"100%"} position="center">
														<Slider
															labelTransition={"skew-up"}
															labelTransitionDuration={100}
															labelTransitionTimingFunction="ease-in-out"
															value={crosshairParams.dot_color_b}
															onChange={(value) =>
																setCrosshairParams({
																	...crosshairParams,
																	dot_color_b: value,
																})
															}
															min={0}
															max={255}
															step={1}
															w={150}
															p={5}
														/>
														<Text size={"xs"}>Color B</Text>
													</Group>
												</>
											)}

											{crosshairParams.dot_useAlpha === 0 && (
												<Group w={"100%"} position="center">
													<Slider
														labelTransition={"skew-up"}
														labelTransitionDuration={100}
														labelTransitionTimingFunction="ease-in-out"
														value={crosshairParams.dot_alpha}
														onChange={(value) =>
															setCrosshairParams({
																...crosshairParams,
																dot_alpha: value,
															})
														}
														min={0}
														max={255}
														step={1}
														w={150}
														p={5}
													/>
													<Text pl={5} size={"xs"}>
														Alpha
													</Text>
												</Group>
											)}
											<Group w={"100%"} position="center">
												<Slider
													value={crosshairParams.dot_size}
													labelTransition={"skew-up"}
													labelTransitionDuration={100}
													labelTransitionTimingFunction="ease-in-out"
													onChange={(value) =>
														setCrosshairParams({
															...crosshairParams,
															dot_size: value,
														})
													}
													min={0}
													max={100}
													step={1}
													w={200}
													p={5}
												/>
												<Text size={"xs"}>Size</Text>
											</Group>
										</Box>
										{crosshairParams.dot_drawOutline === 1 && (
											<Box
												//bg={"indigo"}
												style={{ flexDirection: "column", width: "50%" }}
											>
												<Group w={"100%"} pl={5} position="center" pb={5}>
													<Select
														data={[
															{ value: "0", label: "Black" },
															{ value: "1", label: "White" },
															{ value: "2", label: "Red" },
															{ value: "3", label: "Green" },
															{ value: "4", label: "Blue" },
															{ value: "5", label: "Custom" },
														]}
														transitionProps={{
															duration: 100,
															timingFunction: "ease-in-out",
															transition: "skew-down",
														}}
														label="Outline Color"
														value={crosshairParams.dot_outColor.toString()}
														onChange={(value) => {
															if (value !== null) {
																const numericValue = parseInt(value);
																if (!isNaN(numericValue)) {
																	console.log(numericValue);
																	setCrosshairParams({
																		...crosshairParams,
																		dot_outColor: numericValue,
																	});
																}
															}
														}}
													/>
												</Group>
												{crosshairParams.dot_outColor === 5 && (
													<>
														<Group w={"100%"} position="center">
															<Slider
																labelTransition={"skew-up"}
																labelTransitionDuration={100}
																labelTransitionTimingFunction="ease-in-out"
																value={crosshairParams.dot_outColor_r}
																onChange={(value) =>
																	setCrosshairParams({
																		...crosshairParams,
																		dot_outColor_r: value,
																	})
																}
																min={0}
																max={255}
																step={1}
																w={150}
																p={5}
															/>
															<Text size={"xs"}>Color R</Text>
														</Group>
														<Group w={"100%"} position="center">
															<Slider
																labelTransition={"skew-up"}
																labelTransitionDuration={100}
																labelTransitionTimingFunction="ease-in-out"
																value={crosshairParams.dot_outColor_g}
																onChange={(value) =>
																	setCrosshairParams({
																		...crosshairParams,
																		dot_outColor_g: value,
																	})
																}
																min={0}
																max={255}
																step={1}
																w={150}
																p={5}
															/>
															<Text size={"xs"}>Color G</Text>
														</Group>

														<Group w={"100%"} position="center">
															<Slider
																labelTransition={"skew-up"}
																labelTransitionDuration={100}
																labelTransitionTimingFunction="ease-in-out"
																value={crosshairParams.dot_outColor_b}
																onChange={(value) =>
																	setCrosshairParams({
																		...crosshairParams,
																		dot_outColor_b: value,
																	})
																}
																min={0}
																max={255}
																step={1}
																w={150}
																p={5}
															/>
															<Text size={"xs"}>Color B</Text>
														</Group>
													</>
												)}

												<Group w={"100%"} position="right" pt={5}>
													<Slider
														labelTransition={"skew-up"}
														labelTransitionDuration={100}
														labelTransitionTimingFunction="ease-in-out"
														value={crosshairParams.dot_outlineThickness}
														onChange={(value) =>
															setCrosshairParams({
																...crosshairParams,
																dot_outlineThickness: value,
															})
														}
														min={0}
														max={255}
														step={1}
														w={150}
														pb={5}
														pr={2}
													/>
													<Text pr={20} pb={5} size={"xs"}>
														Outline Thickness
													</Text>
												</Group>
											</Box>
										)}
									</Box>
								)) || <></>}
							</Box>
							<Divider
								color="white"
								m={1}
								label={
									<>
										<FontAwesomeIcon icon={faEye} shake />
										<Box ml={5}>Preview</Box>
									</>
								}
								labelPosition="center"
								size={"lg"}
							/>
						</Box>
						<Box
							style={{
								display: "flex",
								width: "100%",
								alignContent: "center",
								justifyContent: "center",
								alignItems: "center",
							}}
						>
							<canvas
								ref={cRef}
								width={150}
								height={150}
								style={{
									visibility: visible ? "visible" : "hidden",
									zIndex: 100,
									marginTop: 2,
								}}
							/>
						</Box>
					</Box>
				</Container>
			)}
		</>
	);
};

export default CrosshairTool;
