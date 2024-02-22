import { debugData } from "../../utils/debugData";

export const debugCopy = async () => {
  debugData([
    {
      action: "supv_core:copy",
      data: "Hello World!",
    },
  ]);
};