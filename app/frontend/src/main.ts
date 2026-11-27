import "./style/global.css";

import { mount } from "svelte";

import App from "./App.svelte";

// SECTION: Frontend entry point
mount(App, { target: document.getElementById("app")! });
