const express = require("express");
const router = express.Router();
const axios = require("axios");
const multer = require("multer");
require("dotenv").config();

const uploadImage = require("./uploadImage");

const headers = {
  "api-key": process.env.GPT_APIKEY,
  "Content-Type": "application/json",
};
const endpoint = process.env.GPT_ENDPOINT;

// 요약 미들웨어
const summarizeMiddleware = async (req, res, next) => {
  try {
    const { photoText } = req.body; // 텍스트 필드에서 가져오기
    console.log("photoText received:", photoText);

    if (!photoText || !Array.isArray(photoText)) {
      console.log("No photoText provided");
      req.photoTextAI = []; // 텍스트 없으면 null 처리
      return next();
    }
    const summaryPromises = photoText.map(async (text, index) => {
      if (!text.trim()) {
        return "";
      }
      const textData = {
        messages: [
          {
            role: "system",
            content: "You are a helpful assistant that summarizes text.",
          },
          { role: "user", content: `${text} 앞 글을 요약해줘` },
        ],
      };

      try {
        const response = await axios.post(endpoint, textData, { headers });
        return response.data.choices[0]?.message?.content || "";
      } catch (error) {
        console.error("Error summarizing text:", error.message);
        return "";
      }
    });

    // 모든 요약 결과를 기다림
    req.photoTextAI = await Promise.all(summaryPromises);
    console.log("GPT summaries:", req.photoTextAI);

    next();
  } catch (error) {
    console.error("Unexpected error:", error.message);
    req.photoTextAI = [];
    next();
  }
};

module.exports = summarizeMiddleware;
