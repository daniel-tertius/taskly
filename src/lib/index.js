/**
 * @param {Object} a0
 * @param {string | Date | number | null} a0.due_date
 * @param {string | Date | number | null} a0.start_date
 */
export function displayDate({ due_date, start_date }) {
  if (!due_date) return "";

  if (!start_date) {
    return new Date(due_date).toLocaleDateString("af-ZA", {
      year: "numeric",
      month: "short",
      day: "numeric",
    });
  }

  const startDate = new Date(start_date);
  const dueDate = new Date(due_date);

  const startYear = startDate.getFullYear();
  const dueYear = dueDate.getFullYear();
  const startMonth = startDate.getMonth();
  const dueMonth = dueDate.getMonth();

  // Same date
  if (startDate.getTime() === dueDate.getTime()) {
    return startDate.toLocaleDateString("af-ZA", {
      year: "numeric",
      month: "short",
      day: "numeric",
    });
  }

  // Same year and month
  if (startYear === dueYear && startMonth === dueMonth) {
    return `${startDate.getDate()}-${dueDate.getDate()} ${startDate.toLocaleDateString("af-ZA", {
      month: "short",
      year: "numeric",
    })}`;
  }

  // Same year, different month
  if (startYear === dueYear) {
    const startStr = startDate.toLocaleDateString("af-ZA", { month: "short", day: "numeric" });
    const dueStr = dueDate.toLocaleDateString("af-ZA", { month: "short", day: "numeric", year: "numeric" });
    return `${startStr} - ${dueStr}`;
  }

  // Different years
  const startStr = startDate.toLocaleDateString("af-ZA", { year: "numeric", month: "short", day: "numeric" });
  const dueStr = dueDate.toLocaleDateString("af-ZA", { year: "numeric", month: "short", day: "numeric" });
  return `${startStr} - ${dueStr}`;
}

export function displayDateShort(date) {
  if (!date) return "";

  return new Date(date).toLocaleDateString("af-ZA", {
    month: "short",
    day: "numeric",
  });
}

/**
 * @param {number | Date | string} date
 */
export function formatDate(date) {
  if (!date) return 0;

  return new Date(date).toLocaleDateString("en-CA");
}

/**
 * @param {number | Date | string | null} date
 * @returns {string}
 */
export function displayPrettyDate(date) {
  if (!date) return "Geen datum";

  // Check if the date is in the past
  const date_obj = new Date(date);
  const now = new Date();
  now.setHours(0, 0, 0, 0);
  if (date_obj < now) return "Verby";

  date = formatDate(date);
  const today = formatDate(new Date());
  if (date === today) return "Vandag";

  const tomorrow = formatDate(Date.now() + 86400000);
  if (date === tomorrow) return "Môre";

  const day_after_tomorrow = formatDate(Date.now() + 2 * 86400000);
  if (date === day_after_tomorrow) return "Oormôre";

  const this_week_start = new Date();
  this_week_start.setDate(this_week_start.getDate() - this_week_start.getDay());
  const this_week_end = new Date(this_week_start);
  this_week_end.setDate(this_week_end.getDate() + 6);

  const inputDate = new Date(date);
  if (inputDate >= this_week_start && inputDate <= this_week_end) {
    return "Hierdie week";
  }

  const currentMonth = new Date().getMonth();
  const currentYear = new Date().getFullYear();
  const inputMonth = inputDate.getMonth();
  const inputYear = inputDate.getFullYear();

  if (inputMonth === currentMonth && inputYear === currentYear) {
    return "Hierdie maand";
  }

  const nextMonth = (currentMonth + 1) % 12;
  const nextMonthYear = nextMonth === 0 ? currentYear + 1 : currentYear;

  if (inputMonth === nextMonth && inputYear === nextMonthYear) {
    return "Volgende maand";
  }

  return "Later";
}

/**
 * Sorts an array of objects by a specified field name.
 *
 * @template T extends Object
 * @param {Array<T>} array - The array of objects to be sorted.
 * @param {keyof T} field_name - The name of the field to sort by.
 * @param {('asc'|'desc')} [order='asc'] - The order of sorting: 'asc' for ascending, 'desc' for descending.
 * @returns {T[]} - The sorted array.
 *
 * @example
 * const data = [
 *   { name: 'John', age: 25 },
 *   { name: 'Jane', age: 22 },
 *   { name: 'Bob', age: 30 }
 * ];
 *
 * const sortedByName = sortByField(data, 'name');
 * // sortedByName = [{ name: 'Bob', age: 30 }, { name: 'Jane', age: 22 }, { name: 'John', age: 25 }]
 *
 * const sortedByAgeDesc = sortByField(data, 'age', 'desc');
 * // sortedByAgeDesc = [{ name: 'Bob', age: 30 }, { name: 'John', age: 25 }, { name: 'Jane', age: 22 }]
 */
export function sortByField(array, field_name, order = "asc") {
  const is_asc = order === "asc";

  return array.sort((a, b) => {
    if (typeof a[field_name] === "number" && typeof b[field_name] === "number") {
      return is_asc ? a[field_name] - b[field_name] : b[field_name] - a[field_name];
    } else {
      const a_str = String(a[field_name] ?? "");
      const b_str = String(b[field_name] ?? "");

      return is_asc ? a_str.localeCompare(b_str) : b_str.localeCompare(a_str);
    }
  });
}
