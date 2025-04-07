import os from 'os';
import fs from 'fs';

import { createCA, createCert, Certificate } from "mkcert"; // auto generate certificate for dev (latter overide by real certificate by env)

export async function genCertDev(): Promise<Certificate> {
  //check if dev.crt and dev.key exist
  if (fs.existsSync("dev.crt") && fs.existsSync("dev.key")) {
    let cert: Certificate = {
      key: fs.readFileSync("dev.key").toString(),
      cert: fs.readFileSync("dev.crt").toString()
    };

    // latter need to check validity :3
    return cert;
  }

  const ca = await createCA({
    organization: "UwU",
    countryCode: "FR",
    state: "France",
    locality: "developpement",
    validity: 365,
  });

  //list domains
  const nets = os.networkInterfaces();
  const domains = [];

  for (const name of Object.keys(nets)) {
    for (const net of nets[name] || []) {
      domains.push(net.address);
    }
  }
  domains.push("localhost");
  domains.push(os.hostname());

  const cert = await createCert({
    ca: { key: ca.key, cert: ca.cert },
    domains: domains,
    validity: 365
  });

  //save cert in dev.crt and dev.key
  fs.writeFileSync("dev.crt", cert.cert);
  fs.writeFileSync("dev.key", cert.key);

  return cert;
}

export function showServerUrls() {
  const green = '\x1b[32m';
  const reset = '\x1b[0m';
  const nets = os.networkInterfaces();

  console.log(green + 'Server is running at:');

  console.log(' local hostname:');
  console.log(`    https://localhost:3000`);
  console.log(`    https://${os.hostname()}:3000`);

  console.log(' internal:');
  for (const name of Object.keys(nets)) {
    for (const net of nets[name] || []) {
      // internal 
      if (net.family === 'IPv4' && net.internal)
        console.log(`    https://${net.address}:3000`);
    }
  }

  console.log(' external:');
  for (const name of Object.keys(nets)) {
    for (const net of nets[name] || []) {
      // external
      if (net.family === 'IPv4' && !net.internal)
        console.log(`    https://${net.address}:3000`);
    }
  }
  console.log(reset);
}