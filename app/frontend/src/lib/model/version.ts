// SECTION: Frontend Domain Model

// TYPE:
export class Version {
  readonly appVersion: string = "";
  readonly releaseDate: string = "";
  readonly schemaVersion: string = "";

  // FUNCTION: Constructor
  constructor(appVersion: string, releaseDate: string, schemaVersion: string) {
    this.appVersion = appVersion;
    this.releaseDate = releaseDate;
    this.schemaVersion = schemaVersion;
  }
}
