import React from "react";
import { Button, Input, List, Card } from "antd";
import {AddressInput} from '.'

export default function RaribleItemIndexer(props) {
  const [collectionContract, setCollectionContract] = React.useState();
  const [tokenId, setTokenId] = React.useState();
  const [downloading, setDownloading] = React.useState();
  const [items, setItems] = React.useState();
  console.log({writeContracts: props.writeContracts})
  const writeContracts = props.writeContracts
  return (
    <div>
            <div style={{ paddingTop: 32, width: 740, margin: "auto" }}>
      <AddressInput
        ensProvider={props.ensProvider}
        placeholder="contractAddress"
        value={collectionContract}
        onChange={newValue => {
          setCollectionContract(newValue);
        }}
      />
      <Input
        value={tokenId}
        placeholder="tokenId"
        onChange={e => {
          setTokenId(e.target.value);
        }}
      />
      <Button
        style={{ margin: 8 }}
        loading={downloading}
        size="large"
        shape="round"
        type="primary"
        onClick={async () => {
                const getItemByIdUrl = `https://api-staging.rarible.com/protocol/v0.1/ethereum/nft/items/${collectionContract}:${tokenId}`;
                const getItemMetaByIdUrl = `https://api-staging.rarible.com/protocol/v0.1/ethereum/nft/items/${collectionContract}:${tokenId}/meta`;
                setDownloading(true);
                const getItemResult = await fetch(getItemByIdUrl);
                const resultJson = await getItemResult.json();
                const getItemMetaResult = await fetch(getItemMetaByIdUrl);
                const metaResultJson = await getItemMetaResult.json();
                console.log({resultJson})
                console.log({metaResultJson})
                if (resultJson) {
                  setItems([{id: `${collectionContract}:${tokenId}`, name: metaResultJson.name, description: metaResultJson.description}])
                  // setItems([resultJson])
                }
                setDownloading(false);
        }}
      >
        Get Item
      </Button>
    </div>
            <pre style={{ padding: 16, width: 500, margin: "auto", paddingBottom: 150 }}>
              {JSON.stringify(items)}
            </pre>
            <div style={{ width: 640, margin: "auto", marginTop: 32, paddingBottom: 32 }}>
              <List
                bordered
                dataSource={items}
                renderItem={item => {
                  const id = item.id;
                  return (
                    <List.Item key={id}>
                      <Card
                        title={
                          <div>
                            <span style={{ fontSize: 16, marginRight: 8 }}>#{item.name}</span>
                          </div>
                        }
                      >
                        <div>
                          <p>description: {item.description}</p>
                        </div>
                      </Card>
                    </List.Item>
                  );
                }}
              />
            </div>
    </div>
  );
}