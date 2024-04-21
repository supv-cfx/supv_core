import React, { useState } from "react";
import { useDisclosure } from "@mantine/hooks";
import { fetchNui, useNuiEvent } from "../../utils";
import {
	Modal,
	Stack,
	Group,
	Divider,
	TextInput,
	Textarea,
	Checkbox,
	NumberInput,
	Badge,
	Select,
	Accordion,
} from "@mantine/core";
import AnimatedButton from "../modal/components/buttons";
import { faCheck, faXmark } from "@fortawesome/free-solid-svg-icons";
import { Amendes, Articles, Classique } from "./_components";
import { MathDigits, MathRound } from "../../utils";

interface BillingDataProps {
	type?: string;
	title?: string;
	options?: any;
	price?: number;
	description?: string;
	canRemise?: boolean;
	remise?: { min: number; max: number };
	amendesOptions?: any;
	articlesOptions?: any;
  nom?: string;
  prenom?: string;
  entreprise?: string;
}

interface DataProps {
	type?: string;
	[key: string]: any | undefined;
	amount?: number;
	metadata?: any;
	clientType?: string;
  nom?: string;
  prenom?: string;
  entreprise?: string;
}

/**
  type de facture: 'amende', 'item_service', 'price', 'item', 'custom'
  amende: select
  item_service: multi-select + number
  price: number?

  custom => item_service / price
*/

const BillingComponent: React.FC = () => {
	const [opened, { close, open }] = useDisclosure(false);
	const [billingData, setBillingData] = useState<BillingDataProps>({});
	const [data, setData] = useState<DataProps>({});

	const handleSubmit = () => {
		let DATA = {};
		for (const [key, value] of Object.entries(data)) {
			//console.log(`${key}: ${value}`);
			if (typeof value !== "function") {
				DATA = { ...DATA, [key]: value };
			}
		}
		//console.log(JSON.stringify(DATA));
    fetchNui("supv_core:billing:send", DATA, JSON.stringify(DATA));
    close();
    setData({});
    setBillingData({});
	};

	useNuiEvent<BillingDataProps>("supv_core:billing:open", (d) => {
		// if (!data) return console.error("No data received");
		// if (!data.type) return console.error("No type received");
		if (opened) return console.error("Modal already opened");
    console.log(JSON.stringify(d), 'here?  ');
		setBillingData(d);
		setData({
			type: d.type,
			title: d.title,
      nom: d.nom,
      prenom: d.prenom,
      entreprise: d.entreprise,
			price: d.price,
			description: d.description,
      clientType: d.type !== 'amende' ? 'particulier' : undefined,
		});
		open();
	});

	return (
		<>
			<Modal
				key={"modal-billing"}
				opened={opened}
				title="Facture"
				size="lg"
				closeOnClickOutside={false}
				closeOnEscape={false}
				onClose={close}
				centered
				withCloseButton={false}
				withOverlay={false}
				styles={{
					header: {
						background:
							"linear-gradient(45deg, rgba(7, 18, 39, 0.94) 25%, rgba(8, 25, 56, 0.94) 50%, rgba(14, 44, 100, 0.86) 100%)",
					},
					title: {
						fontFamily: "Yellowtail",
						textAlign: "center",
						width: "100%",
						fontSize: 20,
						color: "white",
					},
					body: { background: "rgba(0,0,0,0.5)" },
				}}
				style={{
					background:
						"linear-gradient(45deg, rgba(7, 18, 39, 0.94) 25%, rgba(8, 25, 56, 0.94) 50%, rgba(14, 44, 100, 0.86) 100%)",
				}}
			>
				<Stack>
						<Accordion
							defaultValue={
								billingData.type !== "custom" ? "information" : "selector"
							}
						>
							<Divider variant="solid" />
							{billingData.type === "custom" && (
								<Select
									label="Type de facture"
									data={[
										{ label: "Article(s) & Service", value: "item_service" },
										{ label: "Classique", value: "normal" },
									]}
									onChange={(value) => {
										setData({ ...data, 
                      type: value as string,
                      clientType: data.clientType || "particulier", 
                    });
									}}
								/>
							)}
							<Accordion.Item value="information">
								<Accordion.Control>Information</Accordion.Control>
								<Accordion.Panel>
									<TextInput
										key={"input-title"}
										label="Titre de la facture"
										placeholder="Titre de la facture"
										onChange={(e) =>
											setData({ ...data, title: e.currentTarget.value })
										}
										required
										withAsterisk
									/>
									{billingData.type !== "amende" && (
										<Select
											key={"select-clientType"}
											label="Choisir Pro/Particulier"
											data={[
												{ label: "Particulier", value: "particulier" },
												{ label: "Pro", value: "pro" },
											]}
											onChange={
												(value) =>
													setData({ ...data, clientType: value as string })
												//onChanged("clientType", value as string)
											}
											defaultValue="particulier"
											required
											withAsterisk
										/>
									)}
									{(data.clientType === "pro" &&
										billingData.type !== "amende" && (
											<TextInput
												key={"input-entreprise"}
												label="Nom de l'entreprise"
												onChange={
													(e) =>
														setData({
															...data,
															entreprise: e.currentTarget.value,
														}) /*onChanged("entreprise", value)*/
												}
											/>
										)) ||
										((data.clientType === "particulier" ||
											data.type === "amende") && (
											<Group position="center">
												<TextInput
													key={"input-nom"}
													label="Nom"
                          disabled={data.type === 'amende'}
                          value={data.nom}
													onChange={
														(e) =>
															setData({
																...data,
																nom: e.currentTarget.value,
															}) /*onChanged("nom", value)*/
													}
												/>
												<TextInput
													key={"input-prenom"}
													label="Prénom"
                          disabled={data.type === 'amende'}
                          value={data.prenom}
													onChange={
														(e) =>
															setData({
																...data,
																prenom: e.currentTarget.value,
															}) /*onChanged("prenom", value)*/
													}
												/>
												<TextInput
													key={"input-email"}
													label="Numéro de Téléphone"
													description="Optionnel"
													onChange={
														(e) =>
															setData({
																...data,
																phone: e.currentTarget.value,
															}) /*onChanged("email", value)*/
													}
												/>
											</Group>
										))}
								</Accordion.Panel>
							</Accordion.Item>
							{/** Ici ca va dépendre du type de facutre je vais allez le chercher dans _components*/}
							<Accordion.Item value="price">
								<Accordion.Control>Facturation</Accordion.Control>
								<Accordion.Panel>
									{billingData.type === "amende" && (
										<Amendes
											key={"amendes"}
											data={data}
											options={billingData.options}
											amendesOptions={billingData.amendesOptions}
											//onChanged={onChanged}
											setData={setData}
										/>
									)}
									{data.type === "item_service" && (
										<Articles
											//key={"articles_serv"}
											data={data}
											options={billingData.options}
											articlesOptions={billingData.articlesOptions}
											setData={setData}
										/>
									)}
                  {data.type === "normal" && (
                    <Classique 
                      data={data} 
                      setData={setData} 
                      price={data.price || 0}
                    />  
                  )}
								</Accordion.Panel>
							</Accordion.Item>
							{/** Fin des types de facturation */}
							<Group position="center" pt={5}>
								{billingData.canRemise && (
									<Checkbox
										key={"checkbox-remise"}
										label="Remise"
										pt={data.activeRemise ? 20 : 0}
										//description="Appliquer une remise sur la facture"
										onChange={(e) => {
											const value = e.currentTarget.checked;
											setData({
												...data,
												activeRemise: value,
												remise: undefined,
												amount: data.price
											}); /*onChanged("activeRemise", value)*/
										}}
									/>
								)}
								{(data.activeRemise && (data.price)) && (
									<NumberInput
										key={"input-remise"}
										label="Remise %"
										min={1}
										size="xs"
										max={billingData?.remise?.max}
										value={data.remise}
										defaultValue={data.remise}
										onChange={
											(value) =>
												setData({
													...data,
													remise: value,
													amount: MathRound(
														data.price - (data.price * Number(value)) / 100,
														0
													),
												}) /*onChanged("remise", value)*/
										}
										required
										withAsterisk
									/>
								)}
							</Group>
							<Group position="center">
								<Badge
									color="green"
									variant="dot"
									mt={5}
									mb={5}
									key={"show-amount"}
								>
									{data.price || data.amount
										? MathDigits(data.amount || data.price) + " $"
										: "0 $"}
								</Badge>
							</Group>
							<Accordion.Item value="infoplus">
								<Accordion.Control>
									Information supplémentaire
								</Accordion.Control>
								<Accordion.Panel>
									<Textarea
										key={"textarea-description"}
										label="Description"
										description="Optionnel"
										onChange={
											(e) =>
												setData({
													...data,
													description: e.currentTarget.value,
												}) /*onChanged("description", value)*/
										}
									/>
								</Accordion.Panel>
							</Accordion.Item>
						</Accordion>
						<Group position="center" pb={5}>
							<AnimatedButton
								iconAwesome={faXmark}
								text="Annuler"
								onClick={close}
								color="red.6"
								args={false}
								isDisabled={false /*getData?.canCancel === false || undefined*/}
							/>
							<AnimatedButton
								iconAwesome={faCheck}
								text="Valider"
								onClick={handleSubmit}
								color="teal.6"
								args={true}
							/>
						</Group>
				</Stack>
			</Modal>
		</>
	);
};

export default BillingComponent;
