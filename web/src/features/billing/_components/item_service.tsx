import React, { useEffect } from "react";
import {
	NumberInput,
	TextInput,
	MultiSelect,
	Checkbox,
	rem,
	Group,
	Stack,
	Title,
	ActionIcon,
	Divider,
	Badge,
} from "@mantine/core";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faPlus, faMinus } from "@fortawesome/free-solid-svg-icons";
import { MathRound, MathDigits } from "../../../utils";

interface ArticlesProps {
	data: any;
	options: Array<{ label: string; value: string | number }>;
	articlesOptions: {
		[key: number]: { label: string; amount: number; id: number };
	};
	setData: (data: any) => void;
}

export const Articles: React.FC<ArticlesProps> = ({
	data,
	options,
	articlesOptions,
	setData,
}) => {
	// Mettre à jour le prix total lorsque la quantité change
	useEffect(() => {
		if (!data.articles) return;
		let totalAmount = data.service === true ? data.service_amount : 0;
		Object.keys(data.articles).forEach((article) => {
			totalAmount +=
				data.articles[article].quantity *
				articlesOptions[article as any].amount;
			let newArticles = { ...data.articles };
			newArticles[article].price = MathRound(
				data.articles[article].quantity *
					articlesOptions[article as any].amount,
				0
			);
			//articles[article].price = MathRound(articles[article].quantity * articlesOptions[article as any].amount, 0);
		});

		if (totalAmount !== data.price) {
			if (data.remise) {
				setData({
					...data,
					price: totalAmount,
					amount: MathRound(totalAmount - (totalAmount * data.remise) / 100, 0),
				});
			} else {
				setData({ ...data, price: totalAmount });
			}
		}
	}, [articlesOptions, data]);

	const onMetadata = (value: string[]) => {
		if (value.length === 0) {
			setData({
				...data,
				price: data.service_amount > 0 ? data.service_amount : 0,
				amount:
					data.service_amount && data?.remise > 0
						? MathRound(
								data.service_amount - (data.service_amount * data.remise) / 100,
								0
						  )
						: data.service_amount > 0
						? data.service_amount
						: 0,
				articles: {},
			});
		} else if (value.length > 0) {
			let newArticles = { ...data.articles };
			for (const item of value) {
				if (!articlesOptions[item as any]) continue;
				if (!newArticles[item]) {
					newArticles[item] = {
						quantity: 1,
						price: articlesOptions[item as any].amount,
					};
				} else {
					newArticles[item].quantity = newArticles[item].quantity;
					newArticles[item].price = MathRound(
						newArticles[item].quantity * articlesOptions[item as any].amount,
						0
					);
				}
			}

			// Supprimer les articles qui ne sont plus sélectionnés
			for (const article in newArticles) {
				if (!value.includes(article)) {
					delete newArticles[article];
				}
			}

      let totalAmount = data.service_amount > 0 ? data.service_amount : 0;
      Object.keys(newArticles).forEach((article) => {
        totalAmount += newArticles[article].quantity * articlesOptions[article as any].amount;
      });

      setData({
        ...data,
        price: totalAmount,
        amount: data?.remise > 0 ? MathRound(totalAmount - (totalAmount * data.remise) / 100, 0) : totalAmount,
        articles: newArticles,
      });

			//setData({ ...data, articles: newArticles });
		}

		//updateArticles();
	};

	return (
		<>
			<MultiSelect
				key={"select-item-articles"}
				withinPortal
				data={[...options] as any}
				label="Sélectionner vos articles"
				required
				withAsterisk
        dropdownPosition='top'
				onChange={(value) => {
					onMetadata(value);
				}}
				styles={(theme) => ({
					item: {
						"&[data-selected]": {
							color: "white",
							background: "rgba(14, 44, 100, 0.86)",
							"&, &:hover": {
								color: "white",
								background: "rgba(14, 44, 100, 0.86)",
							},
						},
						"&[data-hovered]": {
							background: "rgba(14, 44, 100, 0.86)",
						},
					},
				})}
			/>

			{data.articles &&
				Object.keys(data.articles).map((article, index) => (
					<Stack key={`${index}`} spacing="xs" align="center">
						<Divider variant="solid" />
						<Group position="apart" w="100%">
							<Title order={6} style={{ alignSelf: "flex-start" }}>
								{articlesOptions[article as any].label}
							</Title>
							<Badge color="green" variant="dot" mt={5} mb={5}>
								{MathDigits(
									articlesOptions[article as any].amount *
										data.articles[article].quantity
								)}{" "}
								$
							</Badge>
							<Group spacing="xs">
								<ActionIcon
									children={<FontAwesomeIcon color="green" icon={faPlus} />}
									onClick={() => {
										const newArticles = { ...data.articles };
										newArticles[article].quantity++;
										newArticles[article].price = MathRound(
											Number(newArticles[article].quantity) *
												articlesOptions[article as any].amount,
											0
										);
                    let totalAmount = data.price;
                    totalAmount += articlesOptions[article as any].amount;
                    setData({
                      ...data,
                      articles: newArticles,
                      price: totalAmount,
                      amount: data?.remise > 0 ? MathRound(totalAmount - (totalAmount * data.remise) / 100, 0) : totalAmount,
                    });
									}}
								/>
								<NumberInput
									hideControls
									value={data.articles[article].quantity}
									onChange={(val) => {
										const newArticles = { ...data.articles };
										// Il faut supprimer l'ancien prix
										let oldPrice = newArticles[article].price;
										let newPrice = data.price;
										newPrice -= oldPrice;
										newArticles[article].quantity = val;
										newArticles[article].price = MathRound(
											Number(val) * articlesOptions[article as any].amount,
											0
										);
										newPrice += newArticles[article].price;
										setData((prev: any) => ({
											...prev,
											articles: newArticles,
											price: newPrice,
											amount:
												data?.remise > 0
													? MathRound(
															newPrice - (newPrice * data.remise) / 100,
															0
													  )
													: newPrice,
										}));
									}}
									min={1}
									styles={{
										input: {
											width: rem(72),
											height: rem(10),
											textAlign: "center",
										},
									}}
								/>
								<ActionIcon
									children={<FontAwesomeIcon color="red" icon={faMinus} />}
									onClick={() => {
										const newArticles = { ...data.articles };
										const quantity = newArticles[article].quantity;
										if (quantity === 1) return;
										newArticles[article].quantity--;
										newArticles[article].price = MathRound(
											newArticles[article].quantity *
												articlesOptions[article as any].amount,
											0
										);
                    let totalAmount = data.price;
                    totalAmount -= articlesOptions[article as any].amount;
                    setData({
                      ...data,
                      articles: newArticles,
                      price: totalAmount,
                      amount: data?.remise > 0 ? MathRound(totalAmount - (totalAmount * data.remise) / 100, 0) : totalAmount,
                    });
									}}
								/>
							</Group>
						</Group>
						<Divider variant="solid" />
					</Stack>
				))}
			<Checkbox
				label="Frais supplémentaire"
        pt={5}
				onChange={(e) => {
					const value = e.currentTarget.checked;
					if (!value && data.service_amount > 0) {
						let totalAmount = data.price;
						totalAmount -= data.service_amount;
						setData({
							...data,
							service: value,
							service_amount: 0,
						});
					} else {
						setData({ ...data, service: value });
					}
				}}
			/>
			{data.service && (
				<>
					<TextInput
						label="Libellé du service"
						description="Exemple: Main d'oeuvre"
						required
						withAsterisk
						onChange={(e) =>
							setData({ ...data, service_label: e.currentTarget.value })
						}
					/>
					<NumberInput
						label="Ajouter un montant"
						required
						withAsterisk
						min={1}
						onChange={(value) => {
              let totalAmount = data.price;
							if (!value || value < 1 || typeof value === "string") {
                totalAmount -= data.service_amount;
              } else if (value && typeof value === 'number' && data.service_amount > 0) {
								totalAmount -= data.service_amount;
                totalAmount += value;
							}
							setData({
								...data,
								service_amount: typeof value === 'number' ? value : 0,
								price: totalAmount,
								amount:
									data?.remise > 0
										? MathRound(
												totalAmount - (totalAmount * data.remise) / 100,
												0
										  )
										: totalAmount,
							});
						}}
					/>
				</>
			)}
		</>
	);
};

export default Articles;
