export class GroupItem {
  name: string;
  count: string;

  constructor(name: string, count: string) {
    this.name = name;
    this.count = count;
  }
}

export class InfoRow {
  label: string;
  value: string;

  constructor(label: string, value: string) {
    this.label = label;
    this.value = value;
  }
}
