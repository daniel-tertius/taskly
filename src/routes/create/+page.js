export async function load() {
  return {
    /** @type {Omit<import("$lib/DB/DB.js").Task, 'id' | 'created_at'>} */
    task: {
      name: "",
      description: "",
      due_date: null,
      start_date: null,
      completed: 0,
      repeat_specific_days: [],
      completed_at: null,
      important: false,
      urgent: false,
      repeat_interval: "",
      repeat_interval_number: 1,
      archived: false,
      category_id: undefined,
    },
  };
}
