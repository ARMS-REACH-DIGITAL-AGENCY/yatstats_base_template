import featureFlags from "@/feature-flags.json";

const GPT51_CODEX_MAX_PREVIEW_ID = "gpt-5.1-codex-max-preview";

const isGpt51CodexMaxPreviewEnabled = Boolean(
  featureFlags[GPT51_CODEX_MAX_PREVIEW_ID] ||
    process.env.NEXT_PUBLIC_ENABLE_GPT51_CODEX_MAX_PREVIEW === "true" ||
    process.env.NEXT_PUBLIC_ENABLE_GPT51_CODEX_MAX_PREVIEW === "1"
);

export const DEFAULT_CHAT_MODEL: string = isGpt51CodexMaxPreviewEnabled
  ? GPT51_CODEX_MAX_PREVIEW_ID
  : "chat-model";

export type ChatModel = {
  id: string;
  name: string;
  description: string;
};

const baseChatModels: ChatModel[] = [
  {
    id: "chat-model",
    name: "Grok Vision",
    description: "Advanced multimodal model with vision and text capabilities",
  },
  {
    id: "chat-model-reasoning",
    name: "Grok Reasoning",
    description:
      "Uses advanced chain-of-thought reasoning for complex problems",
  },
];

export const chatModels: ChatModel[] = isGpt51CodexMaxPreviewEnabled
  ? [
      ...baseChatModels,
      {
        id: GPT51_CODEX_MAX_PREVIEW_ID,
        name: "GPT-5.1-Codex-Max (Preview)",
        description:
          "Latest GPT-5.1 Codex Max preview optimized for coding and reasoning",
      },
    ]
  : baseChatModels;
