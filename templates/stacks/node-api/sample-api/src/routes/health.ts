import { Router } from "express";

const router = Router();

router.get("/health", (_req, res) => {
  res.json({
    status: "ok",
    service: "__PROJECT_NAME__",
  });
});

export default router;
