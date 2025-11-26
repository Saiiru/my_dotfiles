import app from "./app";

const port = process.env.PORT || 3000;

app.listen(port, () => {
  console.log(`[__PROJECT_NAME__] listening on port ${port}`);
});
