import React, { useState } from "react";
import { fetchNui } from "../../utils/fetchNui";
import {
	Text,
	Container,
	Navbar,
	Box,
	Group,
	ActionIcon,
	Image,
	Burger,
	useMantineColorScheme,
	NavLink,
	Accordion,
	Anchor,
	Tooltip,
	Divider,
	ScrollArea,
} from "@mantine/core";
import {
	faMoon,
	faSun,
	faXmarkSquare,
	faPlus,
	faHome,
	faPlay,
	faStop,
	faRedo,
	faSync,
	faFloppyDisk,
} from "@fortawesome/free-solid-svg-icons";
import { ReactMarkdown } from "react-markdown/lib/react-markdown";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { useNuiEvent } from "../../hooks/useNuiEvent";
import { InputEdit, BooleanEdit, BadgeEdit, ArraySwitch, ObjectSwitch, ObjectString } from "./components/index";


const ResourceManager: React.FC = () => {
	const { colorScheme, toggleColorScheme } = useMantineColorScheme();
	const [opened, setOpened] = useState<boolean>(false);
	const [indexNav, setAtIndexNav] = useState<[string, string]>(["", ""]);
	const [navVisible, setNavVisible] = useState<boolean>(true);
	const [getData, setData] = useState<any>({});
	const [onButton, setIdOnButton] = useState<number>(0);

	useNuiEvent("supv:open:rm", async (data) => {
		setData(data);
		await new Promise((resolve) => setTimeout(resolve, 200));
		setOpened(true);
	});

	const handleSubmit = async (resourceName: string, action: string) => {
		await new Promise((resolve) => setTimeout(resolve, 200));
		fetchNui("supv:rm:action", { resource: resourceName, action: action });
	};

	const handleClose = async () => {
		setOpened(false);
		await new Promise((resolve) => setTimeout(resolve, 200));
		fetchNui("supv:rm:close", {});
	};

  const setResourceData = (resourceName: string, file: string, value: any, keyNav: string, index: number) => {
    setData((prevData: any) => {
      const updatedData = { ...prevData };
      updatedData[resourceName].config[file][keyNav][index].value = value;
      return updatedData;
    });
  };

	return (
		<>
			{opened && (
				<Container
					size="sm"
					style={{
						display: "flex",
						justifyContent: "center",
						alignItems: "center",
						height: "100vh",
						//backgroundColor: "yellow",
					}}
				>
					<Box
						style={{
							display: "flex",
							alignItems: "center",
							flexDirection: "column",
						}}
					>
						<Box
							style={{
								width: "100%",
								height: 35,
								display: "flex",
								justifyContent: "space-between",
								alignItems: "center",
								padding: "0 10px",
							}}
							bg={colorScheme === "dark" ? colorScheme : "white"}
						>
							<Group p={0}>
								<Burger
									key={0 + "-burger"}
									opened={!navVisible}
									size={20}
									onClick={() => setNavVisible(!navVisible)}
								/>
								<ActionIcon
									key={1 + "-home"}
									variant="default"
									onClick={() => setAtIndexNav(["", ""])}
									size={20}
								>
									<FontAwesomeIcon icon={faHome} />
								</ActionIcon>
								<ActionIcon
									key={2 + "-theme"}
									variant="default"
									onClick={() => toggleColorScheme()}
									size={20}
								>
									{colorScheme === "dark" ? (
										<FontAwesomeIcon icon={faMoon} />
									) : (
										<FontAwesomeIcon icon={faSun} />
									)}
								</ActionIcon>
								<Anchor
									key={3 + "-anchor"}
									href="https://sup2ak.github.io/docs/supv_core"
									target="_blank"
								>
									<Image
										src="https://raw.githubusercontent.com/SUP2Ak/logo-banner/main/logo_supv10.png"
										width={20}
										height={20}
									/>
								</Anchor>
							</Group>
							<Text align="center">
								Resource Manager :{" "}
								{indexNav[0].length > 0 &&
								indexNav[1].length > 0 &&
								indexNav[1] !== "main"
									? `${indexNav[0]}/${indexNav[1]}`
									: indexNav[0].length > 0 &&
									  indexNav[1].length > 0 &&
									  indexNav[1] === "main"
									? `${indexNav[0]}`
									: "Welcome"}
							</Text>
							<ActionIcon
								variant="light"
								onClick={() => handleClose()}
								color={colorScheme === "dark" ? "dark" : "red"}
								size={20}
							>
								<FontAwesomeIcon icon={faXmarkSquare} />
							</ActionIcon>
						</Box>
						<Box
							style={{
								display: "flex",
								alignItems: "center",
								//overflow: "scroll",
							}}
						>
							{navVisible && (
								<ScrollArea key={"area-nav"} type='hover' h={500} scrollbarSize={4}>
									<Navbar
										height={500}
										p="xs"
										width={{ base: 175 }}
										style={{ marginRight: 0 }}
										//styles={{ root: { overflowY: "scroll" } }}
									>
										<Navbar.Section>
											{getData &&
												Object.keys(getData).map(
													(resourceName: string, i: number) => {
														return (
															<NavLink
																key={`${i}-${resourceName}`}
																label={resourceName}
																onClick={() =>
																	setAtIndexNav([resourceName, "main"])
																}
															>
																{Object.keys(getData[resourceName].config).map(
																	(configKey: string, j: number) => {
																		return (
																			<NavLink
																				key={`${i}.${j}`}
																				label={configKey}
																				onClick={() => {
																					console.log(`${i}.${j}`);
																					setAtIndexNav([
																						resourceName,
																						configKey,
																					]);
																				}}
																			/>
																		);
																	}
																)}
															</NavLink>
														);
													}
												)}
										</Navbar.Section>
									</Navbar>
								</ScrollArea>
							)}
							<Box
								style={{
									height: 500,
									paddingLeft: 10,
									paddingRight: 10,
									wordWrap: "break-word",
									//overflowY: "scroll",
								}}
								w={!navVisible ? 875 : { base: 700 }}
								bg={colorScheme === "dark" ? colorScheme : "white"}
							>
								<ScrollArea key={"area-component"} type='hover' h={490} scrollbarSize={4}>
									{/* Ici le contenu sur lequel je clique dans la NavBar */}
									{(indexNav[0] !== undefined &&
										indexNav[0].length !== 0 &&
										indexNav[1].length !== 0 &&
										indexNav[1] !== "main" &&
										Object.keys(getData[indexNav[0]].config[indexNav[1]]).map(
											(keyNav: string, j: number) => {
												return (
													<Accordion
														chevron={<FontAwesomeIcon icon={faPlus} />}
														key={`${j + 1}.${keyNav}}`}
														styles={{
															chevron: {
																"&[data-rotate]": {
																	transform: "rotate(45deg)",
																},
															},
														}}
													>
														<Accordion.Item value={`${j}`}>
															<Accordion.Control>{keyNav}</Accordion.Control>
															<Accordion.Panel>
																{getData[indexNav[0]].config[indexNav[1]][
																	keyNav
																].map((field: any, i: number) => {
																	return field.type === "input" ? (
																		<InputEdit
																			inputKey={field.id}
																			label={field.label}
																			placeholder={field.placeholder}
																			defaultValue={field.default}
																			description={field.description}
																			currentValue={field.value}
																			resource={indexNav[0]}
																			file={indexNav[1]}
                                      navKey={keyNav}
                                      index={i}
                                      setResourceData={setResourceData}
																		/>
																	) : field.type ===
																	  "text" ? undefined : field.type === //<Text key={i}>{field.label}</Text>
																	  "boolean" ? (
																		<BooleanEdit
																			inputKey={field.id}
																			label={field.label}
																			description={field.description}
																			currentValue={field.value}
																			resource={indexNav[0]}
																			file={indexNav[1]}
                                      navKey={keyNav}
                                      index={i}
                                      setResourceData={setResourceData}
                                      
																		/>
																	) : field.type === "table" ? (
																		<BadgeEdit
																			inputKey={field.id}
																			label={field.label}
																			description={field.description}
																			defaultValue={field.default}
																			resource={indexNav[0]}
																			file={indexNav[1]}
                                      navKey={keyNav}
                                      index={i}
                                      setResourceData={setResourceData}
																		/>
																	) : field.type === 'array-switch' ? (
                                    <ArraySwitch
                                      inputKey={field.id}
                                      label={field.label}
                                      description={field.description}
                                      currentValue={field.value}
                                      resource={indexNav[0]}
                                      file={indexNav[1]}
                                      navKey={keyNav}
                                      groupLabel={field.groupLabel}
                                      index={i}
                                      setResourceData={setResourceData}
                                    />
                                  ) : field.type === 'object-switch' ? (
                                    <ObjectSwitch
                                      inputKey={field.id}
                                      label={field.label}
                                      description={field.description}
                                      currentValue={field.value}
                                      resource={indexNav[0]}
                                      file={indexNav[1]}
                                      navKey={keyNav}
                                      index={i}
                                      setResourceData={setResourceData}
                                    />
                                  ) : field.type === 'object-string' ? (
                                    <ObjectString
                                      inputKey={field.id}
                                      label={field.label}
                                      description={field.description}
                                      currentValue={field.value}
                                      resource={indexNav[0]}
                                      file={indexNav[1]}
                                      navKey={keyNav}
                                      index={i}
                                      setResourceData={setResourceData}
                                      placeHolders={field.placeHolders}
                                    />
                                  ) : null;
																})}
															</Accordion.Panel>
														</Accordion.Item>
													</Accordion>
												);
											}
										)) ||
										(indexNav[0] !== undefined &&
											indexNav[1] === "main" &&
											getData[indexNav[0]].main && (
												<>
													<Group key={indexNav[0]} position="center">
														{getData[indexNav[0]].main.start && (
															<Tooltip
																key={`${indexNav[0]}.00`}
																label="Start Resource"
																position="bottom"
																bg={"gray"}
															>
																<ActionIcon
																	onMouseEnter={() => setIdOnButton(1)}
																	onMouseLeave={() => setIdOnButton(0)}
																	onClick={() => {
																		handleSubmit(indexNav[0], "start");
																	}}
																	color="green"
																>
																	<FontAwesomeIcon
																		icon={faPlay}
																		shake={onButton === 1}
																	/>
																</ActionIcon>
															</Tooltip>
														)}
														{getData[indexNav[0]].main.stop && (
															<Tooltip
																key={`${indexNav[0]}.01`}
																label="Stop Resource"
																position="bottom"
																bg={"gray"}
															>
																<ActionIcon
																	onMouseEnter={() => setIdOnButton(2)}
																	onMouseLeave={() => setIdOnButton(0)}
																	onClick={() => {
																		handleSubmit(indexNav[0], "stop");
																	}}
																	color="red"
																>
																	<FontAwesomeIcon
																		icon={faStop}
																		shake={onButton === 2}
																	/>
																</ActionIcon>
															</Tooltip>
														)}
														{getData[indexNav[0]].main.restart && (
															<Tooltip
																key={`${indexNav[0]}.02`}
																label="Restart Resource"
																position="bottom"
																bg={"gray"}
															>
																<ActionIcon
																	onMouseEnter={() => setIdOnButton(3)}
																	onMouseLeave={() => setIdOnButton(0)}
																	onClick={() => {
																		handleSubmit(indexNav[0], "restart");
																	}}
																	color="orange"
																>
																	<FontAwesomeIcon
																		icon={faRedo}
																		shake={onButton === 3}
																	/>
																</ActionIcon>
															</Tooltip>
														)}
														{getData[indexNav[0]].main.reload && (
															<Tooltip
																key={`${indexNav[0]}.03`}
																label="Reload Resource"
																position="bottom"
																bg={"gray"}
															>
																<ActionIcon
																	onMouseEnter={() => setIdOnButton(4)}
																	onMouseLeave={() => setIdOnButton(0)}
																	onClick={() => {
																		handleSubmit(indexNav[0], "reload");
																	}}
																	color="blue"
																>
																	<FontAwesomeIcon
																		icon={faSync}
																		shake={onButton === 4}
																	/>
																</ActionIcon>
															</Tooltip>
														)}
														<Tooltip
															key={`${indexNav[0]}.save`}
															label="Save Resource"
															position="bottom"
															bg={"gray"}
														>
															<ActionIcon
																onMouseEnter={() => setIdOnButton(5)}
																onMouseLeave={() => setIdOnButton(0)}
																onClick={() => {
																	handleSubmit(indexNav[0], "save");
																}}
																color="violet"
															>
																<FontAwesomeIcon
																	icon={faFloppyDisk}
																	shake={onButton === 5}
																/>
															</ActionIcon>
														</Tooltip>
													</Group>
													<Divider mt={10} mb={10} />
													{getData[indexNav[0]].main.description && (
														<ReactMarkdown>
															{getData[indexNav[0]].main.description}
														</ReactMarkdown>
													)}
												</>
											)) ||
										undefined}
								</ScrollArea>
							</Box>
						</Box>
					</Box>
				</Container>
			)}
		</>
	);
};

export default ResourceManager;